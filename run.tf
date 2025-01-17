resource "google_storage_bucket" "bucket" {
  depends_on = [
    module.project-services
  ]
  name     = "cloud-run-state-${google_project.sandbox-master-project.project_id}"
  location = local.config.global.location
  project  = google_project.sandbox-master-project.project_id
}

resource "google_storage_bucket_iam_member" "bucket_A" {
  depends_on = [
    module.project-services
  ]
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = google_service_account.sandbox-service-account.member
}


resource "google_cloud_run_v2_service" "default" {

  depends_on = [
    google_service_account.sandbox-service-account,
    module.project-services,
    google_storage_bucket.bucket
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

    }

  }
}
