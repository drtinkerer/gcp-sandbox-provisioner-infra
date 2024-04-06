import os
import json
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from google.cloud import resourcemanager_v3, billing_v1
from datetime import timedelta, datetime, UTC
# from cloudrun_src.app import project_manager
from app.project_manager import create_sandbox_project, update_project_billing_info, generate_project_id
from app.tasks import create_deletion_task

app = FastAPI()

class SandboxCreate(BaseModel):
    user_email: EmailStr
    team_name: str = "Team-DevOps"
    requested_duration_hours: int = 2


authorized_domains = os.environ["AUTHORIZED_DOMAIN_NAMES"].split(",")    
team_folders = json.loads(os.environ["AUTHORIZED_TEAM_FOLDERS"])
team_names = list(team_folders.keys())


@app.post("/create_sandbox/")
async def create_user(user_data: SandboxCreate):
    """
    This is doc for create sandbox endpoint
    """
    user_email = user_data.user_email
    team_name = user_data.team_name
    user_email_domain = user_email.split("@")[1]
    folder_id = team_folders[team_name]
    requested_duration_hours = user_data.requested_duration_hours

    # event_type = user_data.event_type
    
    if user_email_domain not in authorized_domains:
        raise HTTPException(status_code=400, detail=f"ERROR 400: User {user_email} doesnt belong to authorized domains {authorized_domains}")

    if team_name not in team_names:
        # folder_id = os.environ[team_name]
        raise HTTPException(status_code=400, detail=f"ERROR 400: Provided team_name {team_name} is invalid. Required value must be one in {team_names}")


    # Check active sandboxes
    request_time = datetime.now(UTC)
    current_timestamp = int(request_time.timestamp())
    project_id = generate_project_id(user_email, current_timestamp)

    print(f"Handling sandbox project creation event for {user_email}")
    response = create_sandbox_project(project_id, folder_id)
    print(f"Project {project_id} creation completed.")

    print(f"Linking project {project_id} to billing account...")
    update_project_billing_info(project_id)
    print(f"Successfuly linked project {project_id} to billing account.")

    print(f"Creating deletion task for Project {project_id} on Google Cloud Tasks queue...")
    create_deletion_task(project_id, request_time, requested_duration_hours)

    print(response)
    return {
        "msg": "we got data succesfully",
        "user_email": user_email,
        "team_name": team_name,
        "project_id": project_id
        # "project_creation_response": response
    }


@app.get('/get_env')
def index():
    return os.environ

@app.get('/multiply')
def multiply(a,b):
    return{'result': int(a)*int(b)}
