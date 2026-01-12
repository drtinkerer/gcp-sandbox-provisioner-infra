module "cloud_run" {
  source = "./modules/cloud_run"
  count  = local.config.deploy_cloud_run ? 1 : 0

  project_id            = module.project_factory.project_id
  name                  = local.config.master_slug
  location              = local.config.default_region
  image                 = local.config.sandbox_provisioner_container_image
  service_account_email = google_service_account.service_account.email
  auth_secret_id        = google_secret_manager_secret.auth_secret.secret_id
  firestore_database_id = local.config.master_slug
  billing_account_id    = local.config.default_billing_account_id
  authorized_regions    = local.config.authorized_regions
  enable_domain_mapping = local.config.enable_domain_mapping
  domain                = local.config.domain

  depends_on = [
    module.project_factory,
    google_secret_manager_secret_version.auth_secret_version,
    google_secret_manager_secret_iam_member.secret_access,
    google_firestore_database.database
  ]
}
