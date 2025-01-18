variable "cloud_tasks_queue_name" {
  description = "Name of the Cloud Tasks Queue"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Name of the Cloud Run Service"
  type        = string
}

variable "cloud_run_container_image" {
  description = "Container image for the Cloud Run Service"
  type        = string
}

variable "service_account_id" {
  description = "ID for the service account"
  type        = string
}

variable "service_account_display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "sandbox_master_project_display_name" {
  description = "Display name for the sandbox master project"
  type        = string
}

variable "sandbox_master_project_id_prefix" {
  description = "Prefix for the sandbox master project ID"
  type        = string
}

variable "sandbox_master_apis_to_enable" {
  description = "List of APIs to enable for the project"
  type        = list(string)
}

variable "org_level_iam_role_title" {
  description = "Title of the IAM role"
  type        = string
}

variable "org_level_iam_role_id" {
  description = "Role ID of the IAM role"
  type        = string
}

variable "org_level_iam_role_permissions" {
  description = "List of permissions for the IAM role"
  type        = list(string)
}

variable "project_level_iam_role_title" {
  description = "Title of the Project Level IAM role"
  type        = string
}

variable "project_level_iam_role_id" {
  description = "Role ID of the Project Level IAM role"
  type        = string
}

variable "project_level_iam_role_permissions" {
  description = "List of permissions for the Project Level IAM role"
  type        = list(string)
}

variable "enable_gcp_provisioner" {
  description = "Feature flag to enable GCP Provisioner"
}

variable "enable_aws_provisioner" {
  description = "Feature flag to enable AWS Provisioner"
}

variable "enable_azure_provisioner" {
  description = "Feature flag to enable Azure Provisioner"
}
