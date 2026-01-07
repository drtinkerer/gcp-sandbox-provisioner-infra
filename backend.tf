terraform {
  backend "gcs" {
    bucket = "cloudpoet-platform-tfstate"
    prefix = "Sandbox Provisioner System/terraform.tfstate"
  }
}
