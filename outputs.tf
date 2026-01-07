output "project_id" {
  description = "The ID of the created project"
  value       = module.project_factory.project_id
}

output "service_account_email" {
  description = "The email of the created provisioner service account"
  value       = google_service_account.service_account.email
}

output "cloud_run_service_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.default.uri
}

output "firestore_database_id" {
  description = "The ID of the Firestore database"
  value       = google_firestore_database.database.name
}

output "auth_secret" {
  description = "The generated authentication secret (sensitive)"
  value       = random_id.auth_secret.b64_std
  sensitive   = true
}
