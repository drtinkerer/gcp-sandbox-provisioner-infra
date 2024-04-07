import os
from google.cloud import tasks_v2
from datetime import timedelta, datetime, UTC
from google.cloud import run_v2

cloud_run_service_id = os.environ["CLOUDRUN_SERVICE_ID"]
master_service_account_email = os.environ["SERVICE_ACCOUNT_EMAIL"]


def get_cloud_run_service_url(cloud_run_service_id):
    client = run_v2.ServicesClient()

    request = run_v2.GetServiceRequest(
        name=cloud_run_service_id
    )

    response = client.get_service(request=request)
    return response.uri


def create_deletion_task(project_id, expiry_timestamp):
    client = tasks_v2.CloudTasksClient()

    cloud_run_service_url = get_cloud_run_service_url(cloud_run_service_id)

    cloud_tasks_queue_id = os.environ["CLOUD_TASKS_DELETION_QUEUE_ID"]

    task_object = tasks_v2.Task(
        name=f"{cloud_tasks_queue_id}/tasks/{project_id}",
        http_request=tasks_v2.HttpRequest(
            url=cloud_run_service_url,
            body=f'{{"project_id":"{project_id}"}}'.encode('utf-8'),
            headers=[("Content-Type", "application/json")],
            oidc_token=tasks_v2.OidcToken(
                service_account_email=master_service_account_email
            )
        ),
        schedule_time=expiry_timestamp
    )


    # Initialize request argument(s)
    request = tasks_v2.CreateTaskRequest(
        parent=cloud_tasks_queue_id,
        task=task_object
    )

    # Make the request
    response = client.create_task(request=request)

    # Handle the response
    return response
