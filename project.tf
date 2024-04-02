resource "random_string" "random_suffix" {
  length  = 2
  special = false
  upper   = false
}

resource "google_project" "sandbox-master-project" {
  name            = local.config.project.master_display_name
  project_id      = "${local.config.project.prefix}-${random_string.random_suffix.id}"
  folder_id       = google_folder.sandbox-master-folder.name
  billing_account = data.google_billing_account.account.id
}

module "project-services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  version    = "~> 14.5"
  project_id = google_project.sandbox-master-project.project_id

  activate_apis = local.config.project.apis_to_enable
}