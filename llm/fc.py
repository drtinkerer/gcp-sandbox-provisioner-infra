import requests
import json
import sys

sandbox_request = sys.argv[1]

# sandbox_request = "give me aws sandbox for 8 hours"

schema = {
  "cloud_provider": {
    "type": "string", 
    "description": "Cloud provider out of 3 options - Google Cloud Platform (GCP), Amazon Web Services (AWS), Microsoft Azure (Azure)"
  }, 
  "time": {
    "type": "float", 
    "description": "Required time duration in hours"
  },
}

payload = {
  "model": "llama2", 
  "messages": [
    {"role": "system", "content": f"You are a helpful AI assistant. The user will enter a requirement for getting temporary sandbox account. User will also provider Cloud provider out of 3 options - Google Cloud Platform (GCP), Amazon Web Services (AWS), Microsoft Azure (Azure) on which they need sandbox. Assistant should reply cloud provider not supported if it is any other than these 3. User will also provide a time duration for which sandbox is needed. If user provides duration in any unit, then it needs to be converted into equivalent hours. Assistant will return Output in JSON using the schema defined here: : {schema}."}, 
    {"role": "user", "content": "I need GCP sandbox for 8 hours"}, 
    {"role": "assistant", "content": "{\"cloud_provider\": \"GCP\", \"lat\": 8.0}"}, 
    {"role": "user", "content": sandbox_request}
  ], 
  "options": {
    "temperature": 0.0
  }, 
  "format": "json", 
  "stream": False
}

response = requests.post("http://localhost:11434/api/chat", json=payload)
cityinfo = json.loads(response.json()["message"]["content"])


print(cityinfo)