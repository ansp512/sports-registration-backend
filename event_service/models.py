from pydantic import BaseModel
from datetime import date, datetime, time, timedelta

class Event(BaseModel):
    event_id: int
    name: str
    event_date: datetime
    category: str
    start_time: datetime
    end_time: datetime