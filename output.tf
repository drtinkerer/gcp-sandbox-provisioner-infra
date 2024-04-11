output "BILLING_ACCOUNT_ID" {
  value = data.google_billing_account.account.id
}

output "ORG_ID" {
  value = data.google_organization.org.org_id
}

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

output "SANDBOX_MASTER_PROJECT_ID" {
  value = google_project.sandbox-master-project.id
}
# output "SERVICE_ACCOUNT_EMAIL" {
#   value = google_service_account.sandbox-service-account.email
# }

# output "GITHUB_IDP_POOL_ID" {
#   value = module.gh_oidc.provider_name
# }