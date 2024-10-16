import psycopg2
import os
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv

load_dotenv()

DB_PARAMS = {
    "dbname": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "host": os.getenv("DB_HOST"),
    "port": os.getenv("DB_PORT")
}

def get_db_connection():
    try:
        # Establish a database connection using the parameters from .env
        conn = psycopg2.connect(**DB_PARAMS)

    except psycopg2.Error as e:
        print(f"Database error: {str(e)}")
        return None
    
    return conn
