resource "google_cloud_run_v2_service" "default" {
  name                = var.name
  location            = var.location
  project             = var.project_id
  deletion_protection = false

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = var.image
      ports {
        container_port = 80
      }
      env {
        name = "AUTH_SECRET"
        value_source {
          secret_key_ref {
            secret  = var.auth_secret_id
            version = "latest"
          }
        }
      }
      env {
        name  = "FIRESTORE_DATABASE_ID"
        value = var.firestore_database_id
      }
      env {
        name  = "DEFAULT_BILLING_ACCOUNT_ID"
        value = var.billing_account_id
      }
      env {
        name  = "FIRESTORE_PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "AUTHORIZED_REGIONS"
        value = join(",", var.authorized_regions)
      }
    }
    service_account = var.service_account_email
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_member" "noauth" {
  project  = var.project_id
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_domain_mapping" "default" {
  count    = var.enable_domain_mapping ? 1 : 0
  location = var.location
  name     = var.domain
  project  = var.project_id

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.default.name
  }
}
