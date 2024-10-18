import json
import os

TEAM_FOLDERS = json.loads(os.environ["AUTHORIZED_TEAM_FOLDERS"])

class BlockTemplates:
    def __init__(self):
        with open('slack_ui_blocks/sandbox_request_form.json', 'r') as file:
            sandbox_request_form = json.load(file)
            sandbox_request_form["callback_id"] = "sandbox_request_form"
            team_name_options = [{'text': {'type': 'plain_text', 'text': team, 'emoji': True},'value': team} for team in TEAM_FOLDERS]
            
            for block in sandbox_request_form["blocks"]:
                if block.get("block_id") == "team_name":
                    block["element"]["options"] = team_name_options
            
        self.sandbox_request_form = sandbox_request_form
        with open('slack_ui_blocks/app_home.json', 'r') as file:
            self.app_home = json.load(file)
