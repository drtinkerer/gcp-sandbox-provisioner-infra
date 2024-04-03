# resource "google_storage_bucket" "bucket" {
#   name                        = "cloud-functions-src-${google_project.sandbox-master-project.project_id}"
#   depends_on                  = [module.project-services]
#   location                    = local.config.global.location
#   uniform_bucket_level_access = true
#   project                     = google_project.sandbox-master-project.project_id
# }

# resource "google_storage_bucket_object" "function-source" {
#   name   = "sp.zip"
#   bucket = google_storage_bucket.bucket.name
#   source = data.archive_file.src.output_path
# }

# module "cloud_functions2" {
#   source = "GoogleCloudPlatform/cloud-functions/google"

#   depends_on = [
#     google_service_account.sandbox-service-account,
#     module.project-services,
#     google_storage_bucket.bucket
#   ]
#   # Required variables
#   function_name     = "gcp-sandbox-manager"
#   project_id        = google_project.sandbox-master-project.project_id
#   function_location = local.config.global.location
#   runtime           = "python311"
#   entrypoint        = "handble_sandbox_request"

#   storage_source = {
#     bucket = google_storage_bucket.bucket.name
#     object = google_storage_bucket_object.function-source.name
#   }

#   service_config = {
#     max_instance_count = 3
#     min_instance_count = 1
#     runtime_env_variables = merge(module.sandbox-teams-folders.ids, {
#       "ORG_ID"                        = data.google_organization.org.org_id,
#       "AUTHORIZED_DOMAIN"             = local.config.global.domain
#       "BILLING_ACCOUNT_ID"            = data.google_billing_account.account.id
#       "LOCATION"                      = local.config.global.location
#       "CLOUD_TASKS_DELETION_QUEUE_ID" = google_cloud_tasks_queue.deletion_tasks_queue.id
#       "SERVICE_ACCOUNT_EMAIL"         = google_service_account.sandbox-service-account.email
#     #   "CLOUD_FUNCTION_URI_GEN_1"      = local.cloud_function_uri
#     })
#   }

# }


# resource "google_cloudfunctions2_function_iam_member" "invokers" {
#   cloud_function = module.cloud_functions2.function_name
#   location       = local.config.global.location
#   member         = google_service_account.sandbox-service-account.member
#   project        = google_project.sandbox-master-project.project_id
#   role           = "roles/cloudfunctions.invoker"
# }

# resource "google_cloudfunctions2_function_iam_member" "member" {
#   cloud_function = module.cloud_functions2.function_name
#   location       = local.config.global.location
#   member         = google_service_account.sandbox-service-account.member
#   project        = google_project.sandbox-master-project.project_id
#   role           = google_organization_iam_custom_role.org-level-custom-role.name

# }
