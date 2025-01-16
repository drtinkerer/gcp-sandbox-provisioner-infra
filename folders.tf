resource "google_folder" "sandbox-master-folder" {
  display_name = local.config.folder.master_display_name
  parent       = local.master_parent_id
}

module "sandbox-teams-folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 4.0"
  parent  = google_folder.sandbox-master-folder.name
  names   = local.config.folder.team_folders
}
