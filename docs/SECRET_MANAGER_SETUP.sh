#!/bin/bash
# Secret Manager Setup Script for GCP Sandbox Provisioner
# This script helps you securely store OAuth and API credentials in Google Secret Manager

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "GCP Sandbox Provisioner - Secret Manager Setup"
echo "================================================"
echo ""

# Get project ID from terraform or prompt user
if [ -f "../terraform.tfstate" ]; then
    PROJECT_ID=$(grep -A 5 '"project_id"' ../terraform.tfstate | grep '"value"' | cut -d'"' -f4 | head -1)
    echo -e "${GREEN}✓${NC} Found project ID from Terraform state: ${YELLOW}${PROJECT_ID}${NC}"
else
    echo -e "${YELLOW}⚠${NC}  Could not find Terraform state file"
    read -p "Enter your GCP project ID: " PROJECT_ID
fi

echo ""
echo "Project ID: ${PROJECT_ID}"
echo ""

# Verify project exists and user has access
echo "Verifying access to project..."
if ! gcloud projects describe "${PROJECT_ID}" &>/dev/null; then
    echo -e "${RED}✗${NC} Cannot access project ${PROJECT_ID}"
    echo "Please ensure:"
    echo "  1. You are authenticated: gcloud auth login"
    echo "  2. Project ID is correct"
    echo "  3. You have permission to access the project"
    exit 1
fi
echo -e "${GREEN}✓${NC} Project access verified"
echo ""

# Prompt for secrets and build JSON
echo "================================================"
echo "You will be prompted for the following secrets:"
echo "  1. OAuth Client ID (from Google Cloud Console)"
echo "  2. OAuth Client Secret (from Google Cloud Console)"
echo "  3. Google AI API Key (from https://makersuite.google.com/app/apikey)"
echo "================================================"
echo ""
read -p "Press Enter to continue..."
echo ""

# Prompt for OAuth Client ID
echo "================================================"
echo "OAuth Client ID"
echo "================================================"
read -p "Enter OAuth Client ID: " OAUTH_CLIENT_ID
echo ""

# Prompt for OAuth Client Secret
echo "================================================"
echo "OAuth Client Secret"
echo "================================================"
read -sp "Enter OAuth Client Secret: " OAUTH_CLIENT_SECRET
echo ""
echo ""

# Prompt for Google AI API Key
echo "================================================"
echo "Google AI API Key"
echo "================================================"
read -sp "Enter Google AI API Key: " GOOGLE_API_KEY
echo ""
echo ""

# Get AUTH_SECRET from Terraform output
echo "================================================"
echo "Retrieving AUTH_SECRET from Terraform..."
echo "================================================"
cd .. || exit 1
AUTH_SECRET=$(terraform output -raw auth_secret 2>/dev/null)
if [ $? -ne 0 ] || [ -z "${AUTH_SECRET}" ]; then
    echo -e "${YELLOW}⚠${NC}  Could not retrieve AUTH_SECRET from Terraform"
    echo "Please enter it manually or press Enter to generate a new one:"
    read -sp "AUTH_SECRET (leave empty to generate): " AUTH_SECRET_INPUT
    echo ""
    if [ -z "${AUTH_SECRET_INPUT}" ]; then
        AUTH_SECRET=$(openssl rand -base64 32)
        echo -e "${GREEN}✓${NC} Generated new AUTH_SECRET"
    else
        AUTH_SECRET="${AUTH_SECRET_INPUT}"
    fi
else
    echo -e "${GREEN}✓${NC} Retrieved AUTH_SECRET from Terraform"
fi
echo ""

# Build JSON secret
echo "================================================"
echo "Creating JSON Secret"
echo "================================================"
JSON_SECRET=$(cat <<EOF
{
  "GOOGLE_CLIENT_ID": "${OAUTH_CLIENT_ID}",
  "GOOGLE_CLIENT_SECRET": "${OAUTH_CLIENT_SECRET}",
  "AUTH_SECRET": "${AUTH_SECRET}",
  "GOOGLE_API_KEY": "${GOOGLE_API_KEY}",
  "NEXTAUTH_URL": "http://localhost:3000"
}
EOF
)

# Update the secret
SECRET_NAME="sandbox-provisioner-system-secret"
echo "Updating secret: ${SECRET_NAME}..."
echo ""

if gcloud secrets describe "${SECRET_NAME}" --project="${PROJECT_ID}" &>/dev/null; then
    echo -e "${YELLOW}⚠${NC}  Secret ${SECRET_NAME} exists. Adding new version..."
    echo "${JSON_SECRET}" | gcloud secrets versions add "${SECRET_NAME}" \
        --project="${PROJECT_ID}" \
        --data-file=-

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Successfully updated secret: ${SECRET_NAME}"
    else
        echo -e "${RED}✗${NC} Failed to update secret: ${SECRET_NAME}"
        exit 1
    fi
else
    echo -e "${RED}✗${NC} Secret ${SECRET_NAME} not found!"
    echo "This secret should have been created by Terraform during bootstrap."
    echo "Please run 'terraform apply' first."
    exit 1
fi

# Verify secret was updated
echo ""
echo "================================================"
echo "Verification"
echo "================================================"
VERSION=$(gcloud secrets versions list "${SECRET_NAME}" --project="${PROJECT_ID}" --limit=1 --format="value(name)")
echo -e "${GREEN}✓${NC} ${SECRET_NAME} (latest version: ${VERSION})"
echo ""

echo -e "${GREEN}✓✓✓ Secret configured successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Update terraform.tfvars with: deploy_cloud_run = true"
echo "  2. Run: terraform apply --auto-approve"
echo ""

echo "================================================"
echo "Security Reminders:"
echo "================================================"
echo "✓ Secrets are encrypted at rest in Google Secret Manager"
echo "✓ Never commit secrets to version control"
echo "✓ Rotate secrets regularly (every 90 days recommended)"
echo "✓ Use IAM to control access to secrets"
echo "================================================"
