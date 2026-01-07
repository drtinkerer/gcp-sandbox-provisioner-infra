resource "google_firestore_database" "database" {
  project     = module.project_factory.project_id
  name        = local.config.master_slug
  location_id = local.config.default_region
  type        = "FIRESTORE_NATIVE"
  depends_on  = [module.project_factory]
}
