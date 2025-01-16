output "CLOUD_RUN_URI" {
  value = google_cloud_run_v2_service.default.uri
}

output "AUTHORIZED_TEAM_NAMES" {
  value = local.config.folder.team_folders
}

output "AUTHORIZED_DOMAINS" {
  value = local.config.global.authorized_domains
}

output "GENERATE_OAUTH_HEADER_COMMAND" {
  value = "gcloud auth print-identity-token"
}
