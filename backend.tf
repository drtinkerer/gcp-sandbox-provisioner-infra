terraform {
  backend "gcs" {
    prefix = "gcp-sandbox-provisioner/"
  }
}
