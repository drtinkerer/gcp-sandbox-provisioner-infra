locals {
  config              = yamldecode(file("config.yaml"))
  master_parent_id    = local.config.folder.parent_id == "default" ? data.google_organization.org.name : local.config.folder.master_parent_id
  cloudrun_service_id = "projects/${google_project.sandbox-master-project.project_id}/locations/${local.config.global.location}/services/${var.cloud_run_service_name}"
}
