resource "google_service_account" "sandbox-service-account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = google_project.sandbox-master-project.project_id
}

resource "google_organization_iam_custom_role" "org-level-custom-role" {
  role_id     = var.org_level_iam_role_id
  org_id      = data.google_organization.org.org_id
  title       = var.org_level_iam_role_title
  description = "Role used by sandbox-provisioner to create/delete projects"
  permissions = var.org_level_iam_role_permissions
}

resource "google_organization_iam_member" "org_level_iam_binding" {
  org_id  = data.google_organization.org.org_id
  role    = google_organization_iam_custom_role.org-level-custom-role.id
  member  = google_service_account.sandbox-service-account.member
}

resource "google_project_iam_custom_role" "project-level-custom-role" {
  project     = google_project.sandbox-master-project.project_id
  role_id     = var.project_level_iam_role_id
  title       = var.project_level_iam_role_title
  description = "Role used by sandbox-provisioner to manage master project resources"
  permissions = var.project_level_iam_role_permissions
}

resource "google_project_iam_member" "project_level_iam_binding" {
  project = google_project.sandbox-master-project.project_id
  role    = google_project_iam_custom_role.project-level-custom-role.id
  member  = google_service_account.sandbox-service-account.member
}
