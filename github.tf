# terraform {
#   required_providers {
#     github = {
#       source  = "integrations/github"
#       version = "~> 6.0"
#     }
#   }
# }

# provider "github" {
#   token = var.git_repo_token # or `GITHUB_TOKEN`
# }

# data "github_repository" "repo" {
#   full_name = local.config.global.github_repository
# }

# resource "github_actions_secret" "wip_provider_id" {
#   repository       = data.github_repository.repo.name
#   secret_name      = "WIP_PROVIDER_ID"
#   plaintext_value  = module.gh_oidc.provider_name
# }


# resource "github_actions_secret" "master_service_account" {
#   repository       = data.github_repository.repo.name
#   secret_name      = "MASTER_SERVICE_ACCOUNT_EMAIL"
#   plaintext_value  = google_service_account.sandbox-service-account.email
# }


# resource "github_actions_secret" "master_project_id" {
#   repository       = data.github_repository.repo.name
#   secret_name      = "SANDBOX_MASTER_PROJECT_ID"
#   plaintext_value  = google_project.sandbox-master-project.project_id
# }

# # resource "github_actions_variable" "example_variable" {
# #   repository       = data.github_repository.repo.name
# #   variable_name    = "SANDBOX_MASTER_PROJECT_ID"
# #   value            = google_project.sandbox-master-project.project_id
# # }

# # resource "github_actions_variable" "example_variable" {
# #   repository       = "example_repository"
# #   variable_name    = "example_variable_name"
# #   value            = "example_variable_value"
# # }