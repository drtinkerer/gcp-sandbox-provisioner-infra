import os
import json
from fastapi import FastAPI, HTTPException
from datetime import timedelta, datetime, UTC
from google.protobuf.timestamp_pb2 import Timestamp

from app.base_models import SandboxCreate, SandboxDelete, SandboxExtend, authorized_domains, team_folders, team_names
from app.project_manager import create_sandbox_project, delete_sandbox_project, update_project_billing_info
from app.utils import generate_project_id, get_active_projects_count, get_cloud_task_expiry_time, delete_cloud_task, list_cloud_tasks
from app.cloud_tasks_manager import create_deletion_task

app = FastAPI()

max_allowed_projects_per_user = int(os.environ["MAX_ALLOWED_PROJECTS_PER_USER"])


@app.post("/create_sandbox/")
def create_sandbox(user_data: SandboxCreate):
    """
    Creates a google cloud sandbox project based on the provided user data.
    """
    user_email = user_data.user_email
    team_name = user_data.team_name
    requested_duration_hours = user_data.requested_duration_hours

    user_email_prefix = user_email.split("@")[0].replace(".", "-")
    user_email_domain = user_email.split("@")[1]
    
    if user_email_domain not in authorized_domains:
        raise HTTPException(status_code=400, detail=f"ERROR 400: User {user_email} doesnt belong to authorized domains {authorized_domains}")

    if team_name not in team_names:
        raise HTTPException(status_code=400, detail=f"ERROR 400: Provided team_name {team_name} is invalid. Required value must be one in {team_names}")

    folder_id = team_folders[team_name]

    # Check active sandboxes
    active_projects_count = get_active_projects_count(user_email_prefix, folder_id)
    if active_projects_count >= max_allowed_projects_per_user:
        raise HTTPException(status_code=400, detail=f"ERROR 400: User {user_email} has reached maximum number of allowed active sandbox projects.")

    request_time = datetime.now(UTC)

    delta = timedelta(hours=requested_duration_hours)
    expiry_timestamp = Timestamp()
    expiry_timestamp.FromDatetime(request_time + delta)

    current_timestamp = int(request_time.timestamp())
    project_id = generate_project_id(user_email, current_timestamp)

    print(f"Handling sandbox project creation event for {user_email}...")
    create_project_response = create_sandbox_project(project_id, folder_id)
    print(f"Successfuly created project {project_id}.")

    print(f"Linking project {project_id} to billing account...")
    updated_project_billing_response = update_project_billing_info(project_id)
    print(f"Successfuly linked project {project_id} to billing account.")

    print(f"Creating deletion task for Project {project_id} on Google Cloud Tasks queue...")
    create_deletion_task_response = create_deletion_task(project_id, project_id, expiry_timestamp)
    print(f"Successfully created deletion task for Project {project_id} on Google Cloud Tasks queue.")
    
    return {
        "detail": "Sandbox project provisioned succesfully",
        "user_email": user_email,
        "team_name": team_name,
        "project_id": project_id,
        "folder_id": folder_id,
        "billing_enabled": updated_project_billing_response.billing_enabled,
        "project_url": f"https://console.cloud.google.com/welcome?project={project_id}",
        "created_at": create_project_response.create_time.strftime("%Y-%d-%m %H:%M:%S UTC"),
        "expires_at": create_deletion_task_response.schedule_time.strftime("%Y-%d-%m %H:%M:%S UTC")
    }


@app.get('/get_env')
def index():
    return os.environ

@app.get('/multiply')
def multiply(a,b):
    return{'result': int(a)*int(b)}

@app.post("/delete_sandbox")
def delete_sandbox(user_data: SandboxDelete):
    """
    Deletes a google cloud sandbox project based on the provided user data.
    """
    project_id = user_data.project_id

    print(f"Handling sandbox project deletion event for {project_id}")
    delete_sandbox_project_response = delete_sandbox_project(project_id)
    print(f"Succssfully deleted Project {project_id}.")

    return {
        "detail": "Sandbox project deleted succesfully",
        "project_id": project_id,
        "deleted_at": delete_sandbox_project_response.delete_time.strftime("%Y-%d-%m %H:%M:%S UTC")
    }


@app.post("/extend_sandbox_duration")
def extend_sandbox(user_data: SandboxExtend):
    """
    Extends the deletion/expirty of the active sandbox project.
    This endpoint needs to be triggered before original scheduled trigger is executed.
    """
    project_id = user_data.project_id
    extend_by_hours = user_data.extend_by_hours
    cloud_tasks_queue_id = os.environ["CLOUD_TASKS_DELETION_QUEUE_ID"]
    try:
        task_id = list_cloud_tasks(project_id)
    except:
        task_id = f"{cloud_tasks_queue_id}/tasks/{project_id}"
        
    new_expiry_timestamp_proto = Timestamp()
    current_expiry_timestamp = get_cloud_task_expiry_time(task_id)
    new_expiry_timestamp_proto.FromSeconds(current_expiry_timestamp + (3600 * extend_by_hours))

    # Delete old task
    print("Deleting task")
    delete_cloud_task_response = delete_cloud_task(task_id)
    print("Deleting task success")
    print(delete_cloud_task_response)

    # Create new task with updated expiry time
    print("Creating updated task with new expiry")
    random_suffix = int(datetime.now(UTC).timestamp())
    updated_task_name = f"{project_id}-extended-{random_suffix}"
    create_deletion_task_response = create_deletion_task(project_id, updated_task_name, new_expiry_timestamp_proto)
    print("Creating updated task with new expiry success")
    print(create_deletion_task_response)

    return {
        "detail": f"Sandbox project expiry extended by {extend_by_hours} hours succesfully",
        "project_id": project_id,
        "new_expiry": create_deletion_task_response.schedule_time.strftime("%Y-%d-%m %H:%M:%S UTC")
    }