# Cloud Run variables
cloud_run_container_image = "drtinkerer/gcp-sandbox-provisioner:1.0.0-slim"
cloud_run_service_name    = "gcp-sandbox-provisioner"

# Cloud Tasks variables
cloud_tasks_queue_name = "sandbox-project-deletion-tasks-queue"

# Sandbox Provisioner service account variables
service_account_id           = "sandbox-master"
service_account_display_name = "Sandbox Master"

# Sandbox Master project variables
sandbox_master_project_display_name = "Sandbox Master"
sandbox_master_project_id_prefix    = "sandbox-master-project"
sandbox_master_apis_to_enable = [
  "cloudtasks.googleapis.com",
  "cloudbilling.googleapis.com",
  "run.googleapis.com",
  "cloudresourcemanager.googleapis.com"
]

# Org Level Custom IAM role variables
org_level_iam_role_title = "Sandbox Provisioner Organization Level Role"
org_level_iam_role_id    = "sandbox_provisioner_organization_level_role"
org_level_iam_role_permissions = [
  "resourcemanager.projects.create",
  "resourcemanager.organizations.get",
  "resourcemanager.projects.get",
  "resourcemanager.projects.list",
  "resourcemanager.folders.list",
  "resourcemanager.folders.get",
  "resourcemanager.projects.createBillingAssignment",
  "resourcemanager.projects.deleteBillingAssignment",
  "billing.resourceAssociations.create",
  "billing.resourceAssociations.delete",
  "billing.resourceAssociations.list",
  "resourcemanager.projects.delete"
]

# Project Level Custom IAM role variables
project_level_iam_role_title = "Sandbox Provisioner Project Level Role"
project_level_iam_role_id    = "sandbox_provisioner_project_level_role"
project_level_iam_role_permissions = [
  "run.services.get",
  "run.routes.invoke",
  "cloudtasks.locations.list",
  "cloudtasks.tasks.create",
  "cloudtasks.tasks.delete",
  "iam.serviceAccounts.actAs",
  "iam.serviceAccounts.get",
  "iam.serviceAccounts.list",
  "iam.serviceAccounts.getAccessToken",
  "iam.serviceAccounts.getOpenIdToken",
  "iam.serviceAccounts.signBlob",
  "iam.serviceAccounts.signJwt"
]

# Feature flags
enable_gcp_provisioner   = "True"
enable_aws_provisioner   = "False"
enable_azure_provisioner = "False"
