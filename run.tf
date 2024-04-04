# resource "google_artifact_registry_repository" "my-repo" {
#   project       = google_project.sandbox-master-project.project_id
#   location      = local.config.global.location
#   repository_id = "gcp-sandbox-provisioner"
#   description   = "example docker repository"
#   format        = "DOCKER"
# }

module "cloud_run" {
  source     = "GoogleCloudPlatform/cloud-run/google"
  version    = "~> 0.10.0"
  depends_on = [google_service_account.sandbox-service-account]

  # Required variables
  service_name          = local.config.cloud_run.service_name
  project_id            = google_project.sandbox-master-project.project_id
  location              = local.config.global.location
  image                 = local.config.cloud_run.container_image
  service_account_email = google_service_account.sandbox-service-account.email
  members               = [google_service_account.sandbox-service-account.member]
  container_concurrency = 5
  env_vars = [
    {
      name : "AUTHORIZED_DOMAIN",
      value : local.config.global.domain
    }
  ]
}

# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "3.0.2"
#     }
#   }
# }


# data "google_service_account_access_token" "repo" {
#   depends_on             = [google_project_iam_custom_role.project-level-custom-role]
#   provider               = google
#   target_service_account = google_service_account.sandbox-service-account.email
#   scopes                 = ["userinfo-email", "cloud-platform"]
# }

# provider "docker" {
#   registry_auth {
#     address  = "${local.config.global.location}-docker.pkg.dev"
#     username = "oauth2accesstoken"
#     password = data.google_service_account_access_token.repo.access_token
#   }
# }

# resource "docker_registry_image" "gar_image" {
#   name     = "${local.config.global.location}-docker.pkg.dev/${google_project.sandbox-master-project.project_id}/${google_artifact_registry_repository.my-repo}/gar-image"

#   build {
#     context = "."
#   }
# }

# resource "docker_registry_image" "helloworld" {
#   name          = docker_image.image.name
#   keep_remotely = true
# }

# resource "docker_image" "image" {
#   name     = "${local.config.global.location}-docker.pkg.dev/${google_project.sandbox-master-project.project_id}/${google_artifact_registry_repository.my-repo.repository_id}/gar-image"
#   build {
#     context = "${path.cwd}/cloudrun_src"
#   }
# }
