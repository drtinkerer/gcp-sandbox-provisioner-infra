import os
from google.cloud import resourcemanager_v3, billing_v1
from datetime import timedelta, datetime, UTC
from app.tasks import create_deletion_task


def create_sandbox_project(project_id, folder_id):

    client = resourcemanager_v3.ProjectsClient()

    project_request = resourcemanager_v3.CreateProjectRequest(
        project=resourcemanager_v3.Project(
            project_id=project_id,
            parent=folder_id,
            display_name=project_id
        )
    )

    operation = client.create_project(request=project_request)
    response = operation.result()

    # Handle the response
    return response


def generate_project_id(user_email, current_timestamp):
    extract_prefix = user_email.split("@")[0].replace(".", "-")
    return f"{extract_prefix}-{current_timestamp}"

def update_project_billing_info(project_id):

    billing_account_id = os.environ["BILLING_ACCOUNT_ID"]
    client = billing_v1.CloudBillingClient()

    # Initialize request argument(s)
    request = billing_v1.UpdateProjectBillingInfoRequest(
        name=f"projects/{project_id}",
        project_billing_info=billing_v1.ProjectBillingInfo(
            billing_account_name=f"billingAccounts/{billing_account_id}"
        )
    )

    # Make the request
    response = client.update_project_billing_info(request=request)
    return response

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