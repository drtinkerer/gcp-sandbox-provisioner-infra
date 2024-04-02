import os
from task import create_deletion_task
from project_manager import delete_project
def multiply(request):
    request_json = request.get_json()
    event_type = request_json["event_type"]
    # num_1 = request_json["num_1"]
    print(request_json)
    if event_type == "sandbox-provision":
        # create_sandbox_project()
        print("creation event")
        create_deletion_task()
    if event_type == "sandbox-nuke":
        print("deletion event")
    return str(os.environ)
