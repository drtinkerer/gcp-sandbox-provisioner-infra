locals {
  config           = yamldecode(file("config.yaml"))
  master_parent_id = local.config.folder.parent_id == "default" ? data.google_organization.org.name : local.config.folder.master_parent_id
  # master_parent_id = local.config.folder.org_as_parent == true ? data.google_organization.org.name : local.config.folder.master_parent_id
  # service_account_member_id = "serviceAccount:${local.config.service_account.account_id}@${local.config.project.account_id}.iam.gserviceaccount.com"
  # cloud_function_uri = "https://${local.config.global.location}-${google_project.sandbox-master-project.project_id}.cloudfunctions.net/${module.cloud_functions2.function_name}"
  sandbox_transformed_folder_ids = [
    for name, value in module.sandbox-teams-folders.ids : {
      name  = name
      value = value
    }
  ]

  cloudrun_env_vars = [
    {
      name : "AUTHORIZED_DOMAINS",
      value : jsonencode(local.config.global.authorized_domains)
    },
    # {
    #   name : "AUTHORIZED_DOMAIN",
    #   value : local.config.global.domain
    # }
  ]

  combined_cloudrun_env_vars = concat(local.cloudrun_env_vars, local.sandbox_transformed_folder_ids)
}

output "merged_list" {
  value = local.combined_cloudrun_env_vars
}
