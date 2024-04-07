from pydantic import BaseModel, EmailStr, Field
import os
import json

authorized_domains = os.environ["AUTHORIZED_DOMAIN_NAMES"].split(",")    
team_folders = json.loads(os.environ["AUTHORIZED_TEAM_FOLDERS"])
team_names = list(team_folders.keys())


class SandboxCreate(BaseModel):
    user_email: EmailStr = Field(..., description=f"Email address of the user requesting the sandbox. User must belong to {authorized_domains}")
    team_name: str = Field("Team-DevOps", description=f"Name of the team to which the sandbox belongs. Team name must be one in {team_names}")
    requested_duration_hours: int = Field(2, description="Requested duration of the sandbox in hours.")


class SandboxDelete(BaseModel):
    project_id: str = Field(...,description="ID of the project to be deleted.")


class SandboxExtend(BaseModel):
    project_id: str = Field(...,description="ID of the project to be extended.")
    extend_by_hours: int = Field(4, description="Number of hours by which to extend the sandbox.")
