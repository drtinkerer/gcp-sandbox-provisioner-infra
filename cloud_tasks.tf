resource "google_cloud_tasks_queue" "deletion_tasks_queue" {
  depends_on = [
    module.project-services,
    google_service_account.sandbox-service-account,
    google_project_iam_custom_role.project-level-custom-role,
    google_project_iam_member.project_level_iam_binding
  ]
  name     = var.cloud_tasks_queue_name
  location = local.config.global.location
  project  = google_project.sandbox-master-project.project_id

  rate_limits {
    max_concurrent_dispatches = 3
    max_dispatches_per_second = 2
  }

  retry_config {
    max_attempts       = 5
    max_retry_duration = "4s"
    max_backoff        = "3s"
    min_backoff        = "2s"
    max_doublings      = 1
  }

  stackdriver_logging_config {
    sampling_ratio = 1
  }
}


data "google_iam_policy" "service_account_user" {
  binding {
    role = "roles/viewer"
    members = [
      google_service_account.sandbox-service-account.member,
    ]
  }
}

resource "google_cloud_tasks_queue_iam_policy" "policy" {
  project     = google_cloud_tasks_queue.deletion_tasks_queue.project
  location    = google_cloud_tasks_queue.deletion_tasks_queue.location
  name        = google_cloud_tasks_queue.deletion_tasks_queue.name
  policy_data = data.google_iam_policy.service_account_user.policy_data
}
