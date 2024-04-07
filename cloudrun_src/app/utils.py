import os
from google.cloud import resourcemanager_v3, run_v2, tasks_v2


def generate_project_id(user_email, current_timestamp):
    extract_prefix = user_email.split("@")[0].replace(".", "-")
    return f"{extract_prefix}-{current_timestamp}"


def get_active_projects_count(user_email_prefix, folder_id):
    client = resourcemanager_v3.ProjectsClient()

    # Initialize request argument(s)
    request = resourcemanager_v3.ListProjectsRequest(
        parent=folder_id,
    )

    # Make the request
    page_result = client.list_projects(request=request)

    project_list = [response.project_id for response in page_result]

    count = 0
    for project in project_list:
        if user_email_prefix in project:
            count += 1
    return count


def get_cloud_run_service_url(cloud_run_service_id):
    client = run_v2.ServicesClient()

    request = run_v2.GetServiceRequest(
        name=cloud_run_service_id
    )

    response = client.get_service(request=request)
    return response.uri


def get_cloud_task_expiry_time(task_id):
    # Create a client
    client = tasks_v2.CloudTasksClient()

    # Initialize request argument(s)
    request = tasks_v2.GetTaskRequest(
        name=task_id
    )

    # Make the request
    response = client.get_task(request=request)

    # Handle the response
    return int(response.schedule_time.timestamp())


def delete_cloud_task(task_id):
    # Create a client
    client = tasks_v2.CloudTasksClient()

    # Initialize request argument(s)
    request = tasks_v2.DeleteTaskRequest(
        name=task_id,
    )

    # Make the request
    response = client.delete_task(request=request)

    return response


def list_cloud_tasks(project_id):
    # Create a client
    client = tasks_v2.CloudTasksClient()
    cloud_tasks_queue_id = os.environ["CLOUD_TASKS_DELETION_QUEUE_ID"]

    # Initialize request argument(s)
    request = tasks_v2.ListTasksRequest(
        parent=cloud_tasks_queue_id
    )

    # Make the request
    page_result = client.list_tasks(request=request)
    # Handle the response
    filtered_task = [response.name for response in page_result if project_id in response.name]

    for response in page_result:
        if project_id in response.name:
            return response.name, int(response.schedule_time.timestamp())