# module "cloud_run" {
#   source     = "GoogleCloudPlatform/cloud-run/google"

#   depends_on = [
#     google_service_account.sandbox-service-account,
#     module.project-services
#   ]

#   version    = "~> 0.10.0"

#   # Required variables
#   service_name          = local.config.cloud_run.service_name
#   project_id            = google_project.sandbox-master-project.project_id
#   location              = local.config.global.location
#   image                 = local.config.cloud_run.container_image
#   service_account_email = google_service_account.sandbox-service-account.email
#   members               = [google_service_account.sandbox-service-account.member]
#   container_concurrency = 5
#   env_vars = local.combined_cloudrun_env_vars
# }

resource "google_storage_bucket" "bucket" {
  name     = "cloud-run-state-${google_project.sandbox-master-project.project_id}"
  location = local.config.global.location
  project = google_project.sandbox-master-project.project_id
}


resource "google_cloud_run_v2_service" "default" {

  depends_on = [
    google_service_account.sandbox-service-account,
    module.project-services,
    google_storage_bucket.bucket
  ]

  name         = local.config.cloud_run.service_name
  project      = google_project.sandbox-master-project.project_id
  location     = local.config.global.location
  launch_stage = "BETA"

  template {
    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"
    # service_account       = google_service_account.sandbox-service-account.email

    containers {
      image = local.config.cloud_run.container_image
      env {
        name  = "BILLING_ACCOUNT_ID"
        value = data.google_billing_account.account.id
      }
      env {
        name = "AUTHORIZED_TEAM_FOLDER_NAMES"
        value = join(",", module.sandbox-teams-folders.names_list)
      }
      env {
        name = "AUTHORIZED_DOMAIN_NAMES"
        value = join(",", local.config.global.authorized_domains)
      }
      env {
        name = "LOCATION"
        value = local.config.global.location
      }
      env {
        name = "ISD"
        value = jsonencode(module.sandbox-teams-folders.ids)
      }
      #   env = merge(module.sandbox-teams-folders.ids, {
      #   "ORG_ID"                        = data.google_organization.org.org_id,
      #   "AUTHORIZED_DOMAIN"             = local.config.global.domain
      #   "BILLING_ACCOUNT_ID"            = data.google_billing_account.account.id
      #   "LOCATION"                      = local.config.global.location
      #   "CLOUD_TASKS_DELETION_QUEUE_ID" = google_cloud_tasks_queue.deletion_tasks_queue.id
      #   "SERVICE_ACCOUNT_EMAIL"         = google_service_account.sandbox-service-account.email
      # })

      volume_mounts {
        name       = "mounted_bucket"
        mount_path = "/var/www"
      }
    }

    volumes {
      name = "mounted_bucket"
      gcs {
        bucket    = google_storage_bucket.bucket.name
        read_only = false
      }
    }
  }
}
