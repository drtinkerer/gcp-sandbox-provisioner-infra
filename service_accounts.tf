resource "google_service_account" "service_account" {
  account_id   = local.config.master_slug
  display_name = "${local.display_name} Service Account"
  project      = module.project_factory.project_id
}

# Grant permissions on Organization if parent is an Organization
resource "google_organization_iam_member" "org_iam" {
  for_each = local.parent_type == "organizations" ? toset(local.provisioner_roles) : []

  org_id = local.parent_id
  role   = each.value
  member = "serviceAccount:${google_service_account.service_account.email}"
}

# Grant permissions on Folder if parent is a Folder
resource "google_folder_iam_member" "folder_iam" {
  for_each = local.parent_type == "folders" ? toset(local.provisioner_roles) : []

  folder = local.config.parent
  role   = each.value
  member = "serviceAccount:${google_service_account.service_account.email}"
}

# Grant Billing Account User role on the Billing Account
resource "google_billing_account_iam_member" "billing_user" {
  billing_account_id = local.config.default_billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.service_account.email}"
}

# Grant Datastore User role to the service account
resource "google_project_iam_member" "datastore_user" {
  project = module.project_factory.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
