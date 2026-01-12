variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "name" {
  description = "Name of the service"
  type        = string
}

variable "location" {
  description = "Region to deploy to"
  type        = string
}

variable "image" {
  description = "Container image"
  type        = string
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}

variable "auth_secret_id" {
  description = "Secret Manager secret ID for AUTH_SECRET"
  type        = string
}

variable "firestore_database_id" {
  description = "Firestore database ID"
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID"
  type        = string
}

variable "authorized_regions" {
  description = "List of authorized regions"
  type        = list(string)
}

variable "enable_domain_mapping" {
  description = "Enable custom domain mapping"
  type        = bool
  default     = false
}

variable "domain" {
  description = "Custom domain"
  type        = string
  default     = ""
}
