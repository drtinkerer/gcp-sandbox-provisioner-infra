# Consolidated JSON secret for application configuration
# This single secret contains all sensitive configuration values needed by the application

resource "google_secret_manager_secret" "app_config" {
  project   = module.project_factory.project_id
  secret_id = "sandbox-provisioner-system-secret"

  replication {
    auto {}
  }

  labels = {
    app       = "sandbox-provisioner"
    terraform = "true"
  }

  depends_on = [module.project_factory]
}

# Initial version with placeholder values
# Users will update this secret after configuring OAuth and obtaining API keys
resource "google_secret_manager_secret_version" "app_config_initial" {
  secret = google_secret_manager_secret.app_config.id

  secret_data = jsonencode({
    GOOGLE_CLIENT_ID     = "YOUR_CLIENT_ID.apps.googleusercontent.com"
    GOOGLE_CLIENT_SECRET = "YOUR_CLIENT_SECRET"
    AUTH_SECRET          = random_id.auth_secret.b64_std
    GOOGLE_API_KEY       = "YOUR_GOOGLE_AI_API_KEY"
    NEXTAUTH_URL         = "http://localhost:3000"
    # Additional keys can be added here as needed:
    # GOOGLE_GEMINI_MODEL = "gemini-2.0-flash-lite"
    # NEXT_PUBLIC_THEME   = "generic"
  })
}

# Grant Cloud Run service account access to the secret
resource "google_secret_manager_secret_iam_member" "app_config_access" {
  project   = module.project_factory.project_id
  secret_id = google_secret_manager_secret.app_config.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.service_account.email}"

  depends_on = [
    google_secret_manager_secret.app_config,
    google_service_account.service_account
  ]
}
