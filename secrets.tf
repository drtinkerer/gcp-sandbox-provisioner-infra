
resource "google_secret_manager_secret" "auth_secret" {
  project   = module.project_factory.project_id
  secret_id = "auth-secret"

  replication {
    auto {}
  }

  depends_on = [module.project_factory]
}

resource "google_secret_manager_secret_version" "auth_secret_version" {
  secret      = google_secret_manager_secret.auth_secret.id
  secret_data = random_id.auth_secret.b64_std
}

# Allow the service account to access the secret
resource "google_secret_manager_secret_iam_member" "secret_access" {
  project   = module.project_factory.project_id
  secret_id = google_secret_manager_secret.auth_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_account.email}"
}
