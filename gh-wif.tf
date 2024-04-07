# module "gh_oidc" {
#   source = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
#   pool_id     = "github-identity-pool"
#   depends_on = [
#     google_project.sandbox-master-project,
#     module.project-services,
#     google_service_account.sandbox-service-account
#   ]
#   project_id  = google_project.sandbox-master-project.project_id
#   provider_id = "github-idp-provider"
#   sa_mapping = {
#     "${google_service_account.sandbox-service-account.account_id}" = {
#       sa_name   = google_service_account.sandbox-service-account.id
#       attribute = "attribute.repository/${local.config.global.github_repository}"
#     }
#   }
# }
