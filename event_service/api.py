from models import Event
from fastapi import APIRouter, HTTPException, Request
import psycopg2
from psycopg2.extras import RealDictCursor
from pydantic import BaseModel

events = APIRouter()

@events.get("/get_all_events", response_model=list[Event])
async def get_all_events(request: Request):
    conn = request.app.state.db_connection
    cur = conn.cursor(cursor_factory=RealDictCursor)

    try:
        cur.execute("SELECT * FROM events.events ORDER BY event_date")
        events = cur.fetchall()

        # Convert the result to a list of Event models
        return [Event(**event) for event in events]

    except psycopg2.Error as e:
        # Handle database errors
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    except Exception as e:
        # Handle other errors
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


@events.get("/getEvents/{user_id}", response_model=list[Event])
async def get_user_events(request: Request, user_id: int):
    conn = request.app.state.db_connection
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        # Query to get events for a specific user
        query = """
            SELECT e.event_id, e.name, e.event_date, e.category, e.start_time, e.end_time
            FROM events.events e
            INNER JOIN events.user_events ue ON e.event_id = ue.event_id
            WHERE ue.user_id = %s
            ORDER BY e.event_date, e.start_time;
            """
        cur.execute(query, (user_id,))
        events = cur.fetchall()
        
        if not events:
            raise HTTPException(status_code=404, detail="No events found for this user")
        
        return events
    except psycopg2.Error as e:
        # Handle database errors
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    except Exception as e:
        # Handle any other errors
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

@events.get("/getUnregisteredEvents/{user_id}", response_model=list[Event])
async def get_unregistered_events(request: Request, user_id: int):
    conn = request.app.state.db_connection
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        # Query to get all events the user is NOT registered for
        query = """
            SELECT e.event_id, e.name, e.event_date, e.category, e.start_time, e.end_time
            FROM events.events e
            LEFT JOIN events.user_events ue ON e.event_id = ue.event_id AND ue.user_id = %s
            WHERE ue.event_id IS NULL
            ORDER BY e.event_date, e.start_time;
            """
        cur.execute(query, (user_id,))
        unregistered_events = cur.fetchall()
        
        if not unregistered_events:
            raise HTTPException(status_code=404, detail="No unregistered events found for this user")
        
        return unregistered_events
    except psycopg2.Error as e:
        # Handle database errors
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    except Exception as e:
        # Handle any other errors
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")

class EventRegistration(BaseModel):
    user_id: int
    event_ids: list[int]

def check_event_limit(user_id: int, new_event_count: int, conn):
    with conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM events.user_events WHERE user_id = %s", (user_id,))
        current_event_count = cur.fetchone()[0]
    
    if current_event_count + new_event_count > 3:
        raise HTTPException(status_code=400, detail="User cannot register for more than 3 events")

def check_time_overlap(user_id: int, event_ids: list[int], conn):
    with conn.cursor() as cur:
        # Get times for new events
        cur.execute("""
            SELECT event_date, start_time, end_time 
            FROM events.events 
            WHERE event_id IN %s
        """, (tuple(event_ids),))
        new_events = cur.fetchall()
        
        # Get times for existing events
        cur.execute("""
            SELECT e.event_date, e.start_time, e.end_time 
            FROM events.events e
            JOIN events.user_events ue ON e.event_id = ue.event_id
            WHERE ue.user_id = %s
        """, (user_id,))
        existing_events = cur.fetchall()
        
        all_events = new_events + existing_events
        
        for i, event1 in enumerate(all_events):
            for event2 in all_events[i+1:]:
                if event1[0] == event2[0]:  # Same date
                    if (event1[1] < event2[2] and event2[1] < event1[2]):
                        raise HTTPException(status_code=400, detail="Time overlap detected between events")

@events.post("/register_events")
async def register_events(request: Request, registration: EventRegistration):
    conn = request.app.state.db_connection
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        # Check event limit
        check_event_limit(registration.user_id, len(registration.event_ids), conn)
        
        # Check time overlap
        check_time_overlap(registration.user_id, registration.event_ids, conn)
        
        # Register for events
        with conn.cursor() as cur:
            for event_id in registration.event_ids:
                cur.execute("""
                    INSERT INTO events.user_events (user_id, event_id) 
                    VALUES (%s, %s) 
                    ON CONFLICT (user_id, event_id) DO NOTHING
                """, (registration.user_id, event_id))
        
        conn.commit()
        return {"message": "Successfully registered for events"}
    
    except HTTPException as e:
        conn.rollback()
        raise e
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@events.delete("/unregister/{user_id}/{event_id}")
async def unregister_event(request: Request, user_id: int, event_id: int):
    conn = request.app.state.db_connection
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    try:
        # Check if the user is registered for the event
        check_query = """
            SELECT 1 FROM events.user_events
            WHERE user_id = %s AND event_id = %s
        """
        cur.execute(check_query, (user_id, event_id))
        if cur.fetchone() is None:
            raise HTTPException(status_code=404, detail="User is not registered for this event")

        # Unregister the user from the event
        delete_query = """
            DELETE FROM events.user_events
            WHERE user_id = %s AND event_id = %s
        """
        cur.execute(delete_query, (user_id, event_id))
        
        if cur.rowcount == 0:
            raise HTTPException(status_code=404, detail="Failed to unregister: User or event not found")
        
        conn.commit()
        return {"message": "Successfully unregistered from the event"}

    except psycopg2.Error as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    
    except HTTPException:
        conn.rollback()
        raise
    
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")