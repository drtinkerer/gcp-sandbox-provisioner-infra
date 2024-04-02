from google.cloud import resourcemanager_v3, billing_v1

def create_project():
    # Create a client
    client = resourcemanager_v3.ProjectsClient()

    project_request = resourcemanager_v3.Project(
        display_name="Bhushan Test",
        project_id="bhushan-test-1st", 
        parent=org
        )

    request = resourcemanager_v3.CreateProjectRequest(project=project_request)

    # Make the request
    operation = client.create_project(request=request)

    print("Waiting for operation to complete...")

    response = operation.result()

    # Handle the response
    print(response)


def update_project_billing_info():

    project_id = "your-project-name"
    billing_account_id = "your-billing-account-id"

    # Create a client
    client = billing_v1.CloudBillingClient()
    project_billing_info = billing_v1.ProjectBillingInfo(
        billing_account_name = f"billingAccounts/{billing_account_id}"
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
