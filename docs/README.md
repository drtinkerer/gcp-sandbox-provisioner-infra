# Documentation

This directory contains setup guides and reference materials for the GCP Sandbox Provisioner infrastructure.

## 📚 Available Documentation

### [OAUTH_SETUP.md](OAUTH_SETUP.md)
Complete step-by-step guide for setting up Google OAuth credentials and deploying the application.

**Covers:**
- OAuth Consent Screen configuration
- OAuth Client ID creation
- Updating the consolidated JSON secret in Secret Manager (secure approach)
- Deploying to Cloud Run

### [SECRET_MANAGER_SETUP.sh](SECRET_MANAGER_SETUP.sh)
Interactive bash script to securely store secrets in Google Secret Manager.

**Usage:**
```bash
cd docs
./SECRET_MANAGER_SETUP.sh
```

**Features:**
- Auto-detects project ID from Terraform state
- Prompts for each secret securely
- Verifies all secrets are created
- Supports updating existing secrets

## 🖼️ Screenshots

The `images/` directory contains annotated screenshots for the OAuth setup process:

| Screenshot | Description |
|------------|-------------|
| `sandbox-oauth-1.png` | OAuth Consent Screen overview |
| `sandbox-oauth-2.png` | OAuth Clients page |
| `sandbox-oauth-3.png` | Creating OAuth Client ID |
| `sandbox-oauth-4.png` | Configuring redirect URIs |
| `sandbox-oauth-5.png` | OAuth credentials created |

## 🔐 Security Best Practices

### ✅ DO:
- Use Google Secret Manager for all sensitive credentials
- Add `*.tfvars` to `.gitignore`
- Rotate credentials every 90 days
- Use Internal OAuth type for Workspace orgs
- Enable audit logging for secret access

### ❌ DON'T:
- Never commit secrets to git
- Never store secrets in `terraform.tfvars`
- Never share secrets via unencrypted channels
- Never hardcode secrets in code
- Never reuse secrets across environments

## 🚀 Quick Start

After completing Bootstrap phase of Terraform:

1. **Configure OAuth** (5 minutes)
   ```bash
   # Follow the URLs from terraform output
   terraform output next_steps
   ```

2. **Store Secrets** (2 minutes)
   ```bash
   cd docs
   ./SECRET_MANAGER_SETUP.sh
   ```

3. **Deploy** (5 minutes)
   ```bash
   # Back to terraform directory
   cd ..
   echo 'deploy_cloud_run = true' > terraform.tfvars
   terraform apply --auto-approve
   ```

## 📋 Prerequisites

- GCP Project created (via Bootstrap Terraform)
- `gcloud` CLI installed and authenticated
- OAuth credentials from Google Cloud Console
- Google AI API key from MakerSuite

## 🆘 Troubleshooting

### "Secret already exists" error

If you need to update a secret:
```bash
echo -n "NEW_VALUE" | gcloud secrets versions add SECRET_NAME \
  --project=YOUR_PROJECT_ID \
  --data-file=-
```

### "Redirect URI mismatch" error

Verify your authorized redirect URIs exactly match:
- Local: `http://localhost:3000/api/auth/callback/google`
- Production: `https://YOUR_DOMAIN/api/auth/callback/google`

No trailing slashes!

### "Cannot access project" error

Ensure you're authenticated:
```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
```

## 📖 Additional Resources

- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Google Secret Manager](https://cloud.google.com/secret-manager/docs)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [NextAuth.js Google Provider](https://next-auth.js.org/providers/google)

## 🔄 Updating Secrets

To rotate or update any secret:

```bash
# Example: Update OAuth client secret
echo -n "NEW_CLIENT_SECRET" | gcloud secrets versions add google-oauth-client-secret \
  --project=YOUR_PROJECT_ID \
  --data-file=-

# Restart Cloud Run to pick up new secret version
gcloud run services update sandbox-provisioner \
  --project=YOUR_PROJECT_ID \
  --region=us-central1
```

## 📝 Notes

- Secrets are automatically versioned in Secret Manager
- Cloud Run can be configured to use specific secret versions
- Old secret versions are retained for rollback capability
- Use IAM to control who can access secrets

---

**Last Updated:** 2026-01-08
**Maintained By:** Infrastructure Team
