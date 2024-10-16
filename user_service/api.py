from models import User
from fastapi import APIRouter, HTTPException, Request
import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2 import sql
from pydantic import BaseModel


users = APIRouter()

@users.get("/validate/{username}")
async def validate_user(request: Request, username: str):
    conn = request.app.state.db_connection
    cur = conn.cursor(cursor_factory=RealDictCursor)

    try:
        # Execute SQL query to get user_id
        query = sql.SQL("SELECT user_id FROM events.users WHERE username = %s")
        cur.execute(query, (username,))
        result = cur.fetchone()
        
        if result:
            return {"user_id": result['user_id']}
        else:
            raise HTTPException(status_code=404, detail="User not found")

    except psycopg2.Error as e:
        # Handle database errors
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

    except HTTPException:
        # Re-raise HTTP exceptions
        raise

    except Exception as e:
        # Handle other errors
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")


@users.post("/create-username/{username}")
async def create_username(request: Request, username: str):
    try:
        # Connect to the PostgreSQL database
        conn = request.app.state.db_connection
        cur = conn.cursor(cursor_factory=RealDictCursor)
        
        # Check if username already exists
        check_query = sql.SQL("SELECT 1 FROM events.users WHERE username = %s")
        cur.execute(check_query, (username,))
        user_exists = cur.fetchone() is not None
        
        if user_exists:
            raise HTTPException(status_code=400, detail="Username already exists")
        
        # Insert new username into the users table
        insert_query = sql.SQL("INSERT INTO events.users (username) VALUES (%s)")
        cur.execute(insert_query, (username,))
        conn.commit()
        
        return {"message": "Username created successfully"}
    except HTTPException as e:
        raise e
    except Exception as e:
        # Handle any database errors
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")