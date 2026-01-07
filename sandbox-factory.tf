resource "google_folder" "folder" {
  display_name = local.display_name
  parent       = local.config.parent
}

module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = local.config.master_slug
  random_project_id = false
  org_id            = local.parent_type == "organizations" ? local.parent_id : null
  folder_id         = local.parent_type == "folders" ? local.parent_id : google_folder.folder.id

  billing_account = local.config.default_billing_account_id

  activate_apis           = local.config.services
  create_project_sa       = false
  default_service_account = "delete"
}
