output "BILLING_ACCOUNT_ID" {
  value = data.google_billing_account.account.id
}

output "ORG_ID" {
  value = data.google_organization.org.org_id
}

output "CLOUD_TASKS_DELETION_QUEUE_ID" {
  value = google_cloud_tasks_queue.deletion_tasks_queue.id
}

output "CLOUD_FUNCTION_URI_GEN_1" {
  value = "https://${local.config.global.location}-${google_project.sandbox-master-project.project_id}.cloudfunctions.net/${module.cloud_functions2.function_name}"
}

output "CLOUD_FUNCTION_URI_GEN_2" {
  value = module.cloud_functions2.function_uri
}

output "SERVICE_ACCOUNT_EMAIL" {
  value = google_service_account.sandbox-service-account.email
}

# output "GITHUB_IDP_POOL_ID" {
#   value = module.gh_oidc.provider_name
# }