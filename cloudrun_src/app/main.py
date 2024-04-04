import os
import json
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from google.cloud import resourcemanager_v3, billing_v1
from datetime import timedelta, datetime, UTC
from cloudrun_src.app.project_manager import create_sandbox_project, update_project_billing_info


app = FastAPI()

class SandboxCreate(BaseModel):
    user_email: EmailStr
    team_name: str = "Team-DevOps"
    # event_type: Literal['sandbox-provision', 'sandbox-nuke']
    requested_duration_hours: int = 2

authorized_domains = ["cloudpoet.in", "example.com"]
# team_names = os.environ["TEAM_NAMES"]
# team_names = json.loads('["Team-DevOps", "Team-3"]')

team_names = ["Team-DevOps", "Team-3"]
    

@app.post("/create_sandbox/")
async def create_user(user_data: SandboxCreate):
    user_email = user_data.user_email
    team_name = user_data.team_name
    user_email_domain = user_email.split("@")[1]
    requested_duration_hours = user_data.requested_duration_hours

    # event_type = user_data.event_type
    
    if user_email_domain not in authorized_domains:
        raise HTTPException(status_code=400, detail=f"ERROR 400: User {user_email} doesnt belong to authorized domains {authorized_domains}")

    if team_name not in team_names:
        # folder_id = os.environ[team_name]
        raise HTTPException(status_code=400, detail=f"ERROR 400: Provided team_name {team_name} is invalid. Required value must be one in {team_names}")

    print(f"Handling sandbox project creation event for {user_email}")
    response = create_sandbox_project(user_email, team_name, requested_duration_hours)
    
    return {
        "msg": "we got data succesfully",
        "user_email": user_email,
        "team_name": team_name,
        # "project_creation_response": response
    }

@app.get('/')
def index():
    return{'value': 'Go to https://math-api-cd-4zunylksjq-uc.a.run.app/docs' }
#this is a change


@app.get('/get_env')
def index():
    return os.environ

@app.get('/multiply')
def multiply(a,b):


    return{'result': int(a)*int(b)}

@app.get('/substract')
def substract(a,b):

    return{'result': int(a)-int(b)}

@app.get('/sum')
def multiply(a,b):
    return{'result': int(a)+int(b)}
