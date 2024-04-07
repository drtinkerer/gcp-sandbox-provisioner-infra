resource "google_service_account" "sandbox-service-account" {
  account_id   = local.config.service_account.account_id
  display_name = local.config.service_account.display_name
  project      = google_project.sandbox-master-project.project_id
}

resource "google_organization_iam_custom_role" "org-level-custom-role" {
  role_id     = local.config.iam_roles.org_level_role.role_id
  org_id      = data.google_organization.org.org_id
  title       = local.config.iam_roles.org_level_role.title
  description = "Role used by sandbox-provisioner to create/delete projects"
  permissions = local.config.iam_roles.org_level_role.permissions
}

resource "google_organization_iam_member" "org_level_iam_binding" {
  org_id  = data.google_organization.org.org_id
  role    = google_organization_iam_custom_role.org-level-custom-role.id
  member  = google_service_account.sandbox-service-account.member
}

resource "google_project_iam_custom_role" "project-level-custom-role" {
  project     = google_project.sandbox-master-project.project_id
  role_id     = local.config.iam_roles.project_level_role.role_id
  title       = local.config.iam_roles.project_level_role.title
  description = "Role used by sandbox-provisioner to manage master project resources"
  permissions = local.config.iam_roles.project_level_role.permissions
}

resource "google_project_iam_member" "project_level_iam_binding" {
  project = google_project.sandbox-master-project.project_id
  role    = google_project_iam_custom_role.project-level-custom-role.id
  member  = google_service_account.sandbox-service-account.member
}


# Allow SA service account use the default GCE account
# resource "google_service_account_iam_member" "gce-default-account-iam" {
#   service_account_id = data.google_compute_default_service_account.default.name
#   role               = "roles/iam.serviceAccountUser"
#   member             = "serviceAccount:${google_service_account.sa.email}"
# }
