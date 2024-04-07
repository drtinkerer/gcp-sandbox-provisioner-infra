from google.cloud import resourcemanager_v3, run_v2


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
