data "google_billing_account" "account" {
  display_name = local.config.global.billing_account_name
  open         = true
}

data "google_organization" "org" {
  domain = local.config.global.cloud_identity_domain
}
