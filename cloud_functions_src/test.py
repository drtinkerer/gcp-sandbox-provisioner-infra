import subprocess
import requests

oauth_token = subprocess.run(
    'gcloud auth print-identity-token', shell=True, capture_output=True, text=True).stdout

headers = {
    'Authorization': 'bearer ' + oauth_token.strip(),
    'Content-Type': 'application/json',
}


def test_function(payload):

    response = requests.post(
        'https://asia-south1-sandbox-master-project-tf.cloudfunctions.net/gcp-sandbox-manager',
        headers=headers,
        json=json_data,
        timeout=70,
    )

    return response.text


# Test 1
json_data = {
    'event_type': 'sandbox-nuke',
    'user_email': 'bhushan.rane@cloudpoet.in',
}

print(f"Testing with missing required keys with payload = {json_data}")
print(test_function(json_data), "\n")

# Test 2
json_data = {
    'user_email': 'bhushan.rane@cloudpoet.in',
    'team_name': 'Team-DevOps'
}

print(f"Testing with missing required keys with payload = {json_data}")
print(test_function(json_data), "\n")

# Test 2
json_data = {
    'event_type': 'sandbox-provision',
    'user_email': 'bhushan.rane@example.in',
    'team_name': 'Team-DevOps'
}

print(f"Testing with unauthorized user email = {json_data}")
print(test_function(json_data), "\n")

# Test 3
json_data = {
    'event_type': 'dummy',
    'user_email': 'bhushan.rane@cloudpoet.in',
    'team_name': 'Team-DevOps'
}

print(f"Testing with wrong event_type = {json_data}")
print(test_function(json_data), "\n")

# Test 3
json_data = {
    'event_type': 'dummy',
    'user_email': 'bhushan.rane@cloudpoet.in',
    'team_name': 'Team-DevOps-zzz'
}

print(f"Testing with wrong team name = {json_data}")
print(test_function(json_data), "\n")


# Testing with malformed email id
json_data = {
    'event_type': 'sandbox-provision',
    'user_email': 'bhushan.ranecloudpoet.in',
    'team_name': 'Team-DevOps'
}

print(f"Testing with wrong email without @ = {json_data}")
print(test_function(json_data), "\n")

# Testing with correct event
json_data = {
    'event_type': 'sandbox-provision',
    'user_email': 'bhushan.rane@cloudpoet.in',
    'team_name': 'Team-DevOps'
}

print(f"Testing with correct event = {json_data}")
print(test_function(json_data), "\n")
