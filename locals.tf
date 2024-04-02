locals {
  config = yamldecode(file("config.yaml"))
  master_parent_id = local.config.folder.org_as_parent == true ? data.google_organization.org.name : local.config.folder.master_parent_id
  # service_account_member_id = "serviceAccount:${local.config.service_account.account_id}@${local.config.project.account_id}.iam.gserviceaccount.com"
  cloud_function_uri = "https://${local.config.global.location}-${google_project.sandbox-master-project.project_id}.cloudfunctions.net/${module.cloud_functions2.function_name}"
}