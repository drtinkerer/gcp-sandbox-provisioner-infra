resource "google_cloud_run_v2_service" "default" {

  depends_on = [
    google_service_account.sandbox-service-account,
    module.project-services
  ]

  name         = var.cloud_run_service_name
  project      = google_project.sandbox-master-project.project_id
  location     = local.config.global.location
  launch_stage = "GA"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    service_account       = google_service_account.sandbox-service-account.email

    containers {
      image = var.cloud_run_container_image
      env {
        name  = "BILLING_ACCOUNT_ID"
        value = data.google_billing_account.account.id
      }
      env {
        name  = "AUTHORIZED_DOMAIN_NAMES"
        value = join(",", local.config.global.authorized_domains)
      }
      env {
        name  = "LOCATION"
        value = local.config.global.location
      }
      env {
        name  = "AUTHORIZED_TEAM_FOLDERS"
        value = jsonencode(module.sandbox-teams-folders.ids)
      }
      env {
        name  = "MAX_ALLOWED_PROJECTS_PER_USER"
        value = local.config.global.max_allowed_projects_per_user
      }
      env {
        name  = "SERVICE_ACCOUNT_EMAIL"
        value = google_service_account.sandbox-service-account.email
      }
      env {
        name  = "ORGANIZATION_ID"
        value = data.google_organization.org.org_id
      }
      env {
        name  = "CLOUD_TASKS_DELETION_QUEUE_ID"
        value = google_cloud_tasks_queue.deletion_tasks_queue.id
      }
      env {
        name  = "CLOUDRUN_SERVICE_ID"
        value = local.cloudrun_service_id
      }
      env {
        name  = "ENABLE_GCP_PROVISIONER"
        value = var.enable_gcp_provisioner
      }
      env {
        name  = "ENABLE_AWS_PROVISIONER"
        value = var.enable_aws_provisioner
      }
      env {
        name  = "ENABLE_AZURE_PROVISIONER"
        value = var.enable_azure_provisioner
      }
    }
  }
}
