import os
from google.cloud import resourcemanager_v3, billing_v1


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


def delete_sandbox_project(project_id):
    # Create a client
    client = resourcemanager_v3.ProjectsClient()

    # Initialize request argument(s)
    request = resourcemanager_v3.DeleteProjectRequest(
        name=f"projects/{project_id}"
    )

    # Make the request
    operation = client.delete_project(request=request)
    response = operation.result()

    # Handle the response
    return response
