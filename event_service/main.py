from fastapi import FastAPI
from api import events
from db import get_db_connection
from fastapi.middleware.cors import CORSMiddleware
from psycopg2.extras import RealDictCursor

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"Events API"}

@app.on_event("startup")
async def startup():
    app.state.db_connection = get_db_connection()

@app.on_event("shutdown")
async def shutdown():
    app.state.db_connection.close()
    print("Database connection closed")

app.include_router(events, prefix='/api/events')