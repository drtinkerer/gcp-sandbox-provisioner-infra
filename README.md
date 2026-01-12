# GCP Sandbox Provisioner - Infrastructure Deployment

## Quick Start

**Bootstrap:** `terraform apply --auto-approve` → Creates infrastructure
**Deploy:** Configure OAuth + Secrets → `terraform apply --auto-approve` → Get Cloud Run URL

## 2-Stage Deployment

### Stage 1 (Bootstrap): Infrastructure Setup
Deploy base infrastructure without Cloud Run.

```bash
terraform init
terraform apply --auto-approve
```

**What you'll see:**
After deployment completes, Terraform will output:
- ✅ `project_id` - Your new GCP project
- ✅ `service_account_email` - Provisioner service account
- ✅ `firestore_database_id` - Firestore database
- ✅ `sandbox_factory_folder_id` - Sandbox parent folder
- ✅ `cloud_run_service_url` - "Bootstrap complete. Set deploy_cloud_run=true to deploy"
- 📋 `next_steps` - Instructions for deployment stage

**What gets created:**
- GCP Project
- Firestore Database
- Service Account with IAM roles
- Sandbox Factory Folder

### Stage 2 (Deploy): Cloud Run Deployment

1. **Get OAuth Credentials:**
   - Go to https://console.cloud.google.com/apis/credentials
   - Create OAuth 2.0 Client ID
   - Application type: Web application
   - Save Client ID and Client Secret

2. **Get Google AI API Key:**
   - Go to https://makersuite.google.com/app/apikey
   - Create API key

3. **Build and push container:**
   ```bash
   PROJECT_ID="<your-project-id-from-bootstrap>"

   docker build -t gcr.io/${PROJECT_ID}/sandbox-provisioner:latest .
   docker push gcr.io/${PROJECT_ID}/sandbox-provisioner:latest
   ```

4. **Create terraform.tfvars:**
   ```hcl
   deploy_cloud_run     = true
   container_image      = "gcr.io/YOUR_PROJECT_ID/sandbox-provisioner:latest"
   google_client_id     = "YOUR_CLIENT_ID"
   google_client_secret = "YOUR_CLIENT_SECRET"
   google_api_key       = "YOUR_API_KEY"
   google_gemini_model  = "gemini-2.0-flash-lite"
   ```

5. **Deploy Cloud Run:**
   ```bash
   terraform apply --auto-approve
   ```

   **What you'll see:**
   After deployment completes, Terraform will output:
   - ✅ `cloud_run_service_url` - **https://your-service-xxxxx-region.a.run.app** ← Your application URL!
   - 📋 `next_steps` - "Cloud Run deployed! Update OAuth redirect URI with the URL above."

6. **Update OAuth redirect URI:**
   - Go back to OAuth client settings
   - Add: `https://YOUR_CLOUD_RUN_URL/api/auth/callback/google`
   - Save

## Configuration

### bootstrap-config.yaml
Edit this file with your GCP organization details before bootstrap.

### variables.tf
Variables for deployment stage (OAuth, API keys, container image).

## File Organization

### Bootstrap Files (Always deployed)
- `bootstrap-config.yaml` - GCP organization configuration
- `sandbox-factory.tf` - Folder and project setup
- `service_accounts.tf` - Service account and IAM
- `firestore.tf` - Firestore database
- `secrets.tf` - Random secret generation
- `locals.tf` - Local variables
- `outputs.tf` - Terraform outputs

### Deployment Files (Deployed when deploy_cloud_run=true)
- `variables.tf` - OAuth, API keys, container image variables
- `cloud_run.tf` - Cloud Run service (conditional)
- `cloud_run_domain.tf` - Custom domain mapping (optional)
- `terraform.tfvars` - Your secrets (gitignored, create from .example)
- `terraform.tfvars.example` - Template for deployment configuration

## Security Note

Add `terraform.tfvars` to `.gitignore` (already configured) to prevent committing secrets.
