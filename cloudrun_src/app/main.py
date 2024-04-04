from fastapi import FastAPI
from google.cloud import resourcemanager_v3, billing_v1
from datetime import timedelta, datetime, UTC

from pydantic import BaseModel
app = FastAPI()

class UserCreate(BaseModel):
    user_id: int
    username: str

@app.post("/create_user/")
async def create_user(user_data: UserCreate):
    user_id = user_data.user_id
    username = user_data.username
    return {
        "msg": "we got data succesfully",
        "user_id": user_id,
        "username": username,
    }

@app.get('/')
def index():
    return{'value': 'Go to https://math-api-cd-4zunylksjq-uc.a.run.app/docs' }
#this is a change

@app.get('/multiply')
def multiply(a,b):


    return{'result': int(a)*int(b)}

@app.get('/substract')
def substract(a,b):

    return{'result': int(a)-int(b)}

@app.get('/sum')
def multiply(a,b):
    return{'result': int(a)+int(b)}
