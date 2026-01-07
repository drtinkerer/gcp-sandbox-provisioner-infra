resource "google_cloud_run_v2_service" "default" {
  name     = "${local.config.master_slug}-nginx"
  location = local.config.default_region
  project  = module.project_factory.project_id

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = local.config.sandbox_provisioner_container_image
      ports {
        container_port = 80
      }
      env {
        name = "AUTH_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.auth_secret.secret_id
            version = "latest"
          }
        }
      }
      env {
        name  = "FIRESTORE_DATABASE_ID"
        value = local.config.master_slug
      }
      env {
        name  = "DEFAULT_BILLING_ACCOUNT_ID"
        value = local.config.default_billing_account_id
      }
      env {
        name  = "FIRESTORE_PROJECT_ID"
        value = module.project_factory.project_id
      }
      env {
        name  = "AUTHORIZED_REGIONS"
        value = join(",", local.config.authorized_regions)
      }
    }
    service_account = google_service_account.service_account.email
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    module.project_factory,
    google_secret_manager_secret_version.auth_secret_version,
    google_secret_manager_secret_iam_member.secret_access
  ]
}

# Make it accessible publicly (optional but typical for "default nginx" demo)
resource "google_cloud_run_v2_service_iam_member" "noauth" {
  project  = module.project_factory.project_id
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
