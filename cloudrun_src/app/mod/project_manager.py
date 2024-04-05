import os
from google.cloud import resourcemanager_v3, billing_v1
from datetime import timedelta, datetime, UTC


def create_sandbox_project(user_email, folder_id, requested_duration_hours):
    # Create a client
    client = resourcemanager_v3.ProjectsClient()

    current_timestamp = int(datetime.now(UTC).timestamp())
    expiry_timestamp = current_timestamp + (requested_duration_hours * 3600)

    # Generate random project id from user email
    project_id = generate_project_id(user_email, current_timestamp)

    request_object = resourcemanager_v3.Project(
        project_id=project_id,
        parent=folder_id
    )

    project_request = resourcemanager_v3.CreateProjectRequest(
        project=request_object)

    # Make the request
    print("Waiting for project creation to complete...")
    operation = client.create_project(request=project_request)
    print("Project creation completed.")
    print(f"Linking project {project_id} to billing account...")
    update_project_billing_info(user_email, project_id)
    print(f"Successfuly linked project {project_id} to billing account.")
    response = operation.result()
    print(response)

    # Handle the response
    return (response)


def generate_project_id(user_email, current_timestamp):
    extract_prefix = user_email.split("@")[0].replace(".", "-")
    return f"extract_prefix-{current_timestamp}"


def update_project_billing_info(user_email, project_id):

    project_id = "your-project-name"
    billing_account_id = os.environ["BILLING_ACCOUNT_ID"]

    # Create a client
    client = billing_v1.CloudBillingClient()
    project_billing_info = billing_v1.ProjectBillingInfo(
        billing_account_name=f"billingAccounts/{billing_account_id}"
    )
    # Initialize request argument(s)
    request = billing_v1.UpdateProjectBillingInfoRequest(
        name=f"projects/{project_id}",
    )

    # Make the request
    response = client.update_project_billing_info(request=request)

    # Handle the response
    print(response)


def delete_project():
    # Create a client
    # client = resourcemanager_v3.ProjectsClient()

    # project_request = resourcemanager_v3.Project(
    #     display_name="Bhushan Test",
    #     project_id="bhushan-test-1st",
    #     parent=org
    #     )

    # request = resourcemanager_v3.CreateProjectRequest(project=project_request)

    # # Make the request
    # operation = client.create_project(request=request)

    # print("Waiting for operation to complete...")

    # response = operation.result()

    # Handle the response
    # print(response)
    return None
