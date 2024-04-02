import os
from google.cloud import tasks_v2
from google.protobuf.timestamp_pb2 import Timestamp
from datetime import timedelta, datetime, UTC


def create_deletion_task():
    client = tasks_v2.CloudTasksClient()

    now = datetime.now(UTC)
    delta = timedelta(hours=0.1)

    expiry_timestamp = Timestamp()
    expiry_timestamp.FromDatetime(now + delta)

    cloud_tasks_queue_id = os.environ["CLOUD_TASKS_DELETION_QUEUE_ID"]

    http_request_object = tasks_v2.HttpRequest(
        url=os.environ["CLOUD_FUNCTION_URI_GEN_1"],
        body=b'{"event_type":"sandbox-nuke"}',
        headers=[("Content-Type", "application/json")],
        oidc_token=tasks_v2.OidcToken(
            service_account_email=os.environ["SERVICE_ACCOUNT_EMAIL"]
        )
    )

    task_object = tasks_v2.Task(
        name=f"{cloud_tasks_queue_id}/tasks/bhushanrane{int(now.timestamp())}",
        http_request=http_request_object,
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
