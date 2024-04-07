from pydantic import BaseModel, EmailStr


class SandboxCreate(BaseModel):
    user_email: EmailStr
    team_name: str = "Team-DevOps"
    requested_duration_hours: int = 2


class SandboxDelete(BaseModel):
    project_id: str


class SandboxExtend(BaseModel):
    project_id: str
    extend_by_hours: int = 4
