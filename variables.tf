# ============================================================================
# STEP 2 VARIABLES - Provide these after Step 1 is complete
# ============================================================================

# Set to true when you're ready to deploy Cloud Run (Step 2)
variable "deploy_cloud_run" {
  description = "Enable Cloud Run deployment (Step 2)"
  type        = bool
  default     = false
}

# OAuth Configuration (get these after creating OAuth client in Google Console)
variable "google_client_id" {
  description = "Google OAuth Client ID - Get from Google Cloud Console after Step 1"
  type        = string
  default     = ""
  sensitive   = false # Not a secret - appears in browser anyway
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret - Get from Google Cloud Console after Step 1"
  type        = string
  default     = ""
  sensitive   = true
}

# Google AI Configuration
variable "google_api_key" {
  description = "Google AI API Key - Get from https://makersuite.google.com/app/apikey"
  type        = string
  default     = ""
  sensitive   = true
}

variable "google_gemini_model" {
  description = "Gemini model to use (default: gemini-2.0-flash-lite)"
  type        = string
  default     = "gemini-2.0-flash-lite"
}

# Container Configuration
variable "container_image" {
  description = "Container image to deploy (Step 2)"
  type        = string
  default     = "nginx:latest" # Placeholder for Step 1
}
