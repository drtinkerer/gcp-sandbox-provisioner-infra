data "google_billing_account" "account" {
  display_name = local.config.global.billing_account_name
  open         = true
}

data "google_organization" "org" {
  domain = local.config.global.domain
}

data "archive_file" "src" {
  type        = "zip"
  source_dir  = "./cloud_functions_src"
  output_path = "/tmp/sp.zip"
}
