locals {
  config = yamldecode(file("${path.module}/bootstrap-config.yaml"))

  parent_type = split("/", local.config.parent)[0]
  parent_id   = split("/", local.config.parent)[1]

  display_name = title(replace(local.config.master_slug, "-", " "))

  # Roles to grant on the parent (Org or Folder)
  provisioner_roles = [
    "roles/resourcemanager.folderCreator",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/billing.projectManager",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/iam.securityAdmin",
  ]
}

resource "random_id" "auth_secret" {
  byte_length = 32
}
