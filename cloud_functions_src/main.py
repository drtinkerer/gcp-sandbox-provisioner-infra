import os
# from task import create_deletion_task
from project_manager import create_sandbox_project, update_project_billing_info

"""
expected event example -

{
"event_type":"sandbox-provision"| "sandbox-nuke",
"user_email": "bhushan.rane@example.com",
"team_name": "Team-DevOps"
"requested_duration_hours": "8"
}

"""

authorized_domain = os.environ["AUTHORIZED_DOMAIN"]


def handble_sandbox_request(request):
    request_json = request.get_json()
    try:
        event_type = request_json["event_type"]
        user_email = request_json["user_email"]
        team_name = request_json["team_name"]
        requested_duration_hours = int(request_json.get("requested_duration_hours", 2))
    except:
        return ("ERROR 400: Payload must contain keys event_type, team_name and user_email.", 400)

    if user_email.split("@")[1] != os.environ["AUTHORIZED_DOMAIN"]:
        return (f"ERROR 400: User {user_email} doesnt belong to {authorized_domain}", 400)
    
    if team_name in os.environ.keys():
        folder_id = os.environ[team_name]
    else:
        return (f"ERROR 400: Provided Team(Folder) name {team_name} is invalid", 400)


    if event_type == "sandbox-provision":
        print(f"Handling sandbox project creation event for {user_email}")
        # create_sandbox_project(user_email, team_name, requested_duration_hours)
        # create_deletion_task(request_json)
        return (f"OK 200: Sandbox project creation for {user_email} successful.", 200)

    elif event_type == "sandbox-nuke":
        print(f"Handling sandbox project deletion event for {user_email}")
        return (f"OK 200: Sandbox project deletion for {user_email} successful.", 200)

    else:
        return ("ERROR 400: Invalid value for event_type. Value must be either sandbox-provision or sandbox-nuke",400)
    
    return str(os.environ)
