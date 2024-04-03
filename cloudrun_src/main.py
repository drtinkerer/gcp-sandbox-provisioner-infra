from fastapi import FastAPI
from google.cloud import resourcemanager_v3, billing_v1
from datetime import timedelta, datetime, UTC


app= FastAPI()

@app.get('/')
def index():
    return{'value': 'Go to https://math-api-cd-4zunylksjq-uc.a.run.app/docs' }
#this is a change

@app.get('/multiply')
def multiply(a,b):
    return{'result': int(a)*int(b)}

@app.get('/substract')
def substract(a,b):

    return{'result': int(a)-int(b)}

@app.get('/sum')
def multiply(a,b):
    return{'result': int(a)+int(b)}


def create_sandbox_project(user_email, folder_id, requested_duration_hours):
    # Create a client
    client = resourcemanager_v3.ProjectsClient()

    # Generate random project id from user email
    project_id = "bhushanrane-22149520"

    request_object = resourcemanager_v3.Project(
        project_id=project_id,
        parent="291146829076"
    )

    project_request = resourcemanager_v3.CreateProjectRequest(
        project=request_object)

    # Make the request
    operation = client.create_project(request=project_request)
    response = operation.result()
    print(response)

    # Handle the response
    return (response)