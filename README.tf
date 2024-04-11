# Welcome to GCP Sandbox Provisioner by ollion.com !

The GCP Sandbox Provisioner is a project designed to provide time-based Google Cloud Platform (GCP) sandbox projects that automatically expire after a specified duration.

With this tool, users can quickly and easily create temporary sandbox environments on GCP for testing, development, or learning purposes. These sandbox projects are automatically provisioned with the necessary resources and configurations, allowing users to explore and experiment with GCP services without worrying about long-term commitments or resource cleanup.

Additionally, users have the flexibility to extend the duration of their sandbox projects on the go, allowing for continued exploration and experimentation beyond the initial expiration period.

Once the specified time duration elapses, the sandbox projects are automatically deleted, helping to prevent unnecessary costs and resource clutter.

Whether you're a developer looking to test new GCP features, a student learning about cloud computing, or an organization seeking temporary environments for training or experimentation, the GCP Sandbox Provisioner provides a convenient and cost-effective solution for creating and managing temporary GCP sandbox projects.

## Quickstart Guide: Provisioning GCP Sandbox Projects with Terraform

### Prerequisites
Before you begin, ensure you have the following prerequisites:

 - **Google Cloud Platform (GCP) Account**: You must have access to a GCP account with the necessary permissions to create and manage projects. The roles required can be at the organization or folder level, depending on your organization's setup. Required roles being 
	 - Owner
	 - Billing Account Administrator

 - **Terraform Installed**: Ensure you have Terraform installed on your local machine. You can follow the instructions provided in the [official Terraform documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli).

 - **GCP Authentication**: Before running Terraform commands, authenticate with your GCP account using the following commands:
   ```
   gcloud auth login
   gcloud auth application-default login
   ```
   These commands will prompt you to log in with your GCP account credentials and set up the necessary authentication for both interactive and non-interactive sessions.

### Step 1: Clone the Repository
Clone the GCP Sandbox Provisioner repository from GitHub:
```
git clone https://github.com/your-username/gcp-sandbox-provisioner.git
cd gcp-sandbox-provisioner
```

### Step 2: Configure Terraform Config yaml file
Edit the `config.yaml` file to specify the required variables such as project name, region, authorized domains, authorized teams etc. 

### Step 3: Initialize Terraform
Initialize Terraform in the project directory:
```
terraform init
```

### Step 4: Apply Configuration
Apply the Terraform configuration to provision the GCP sandbox projects. Use the `--auto-approve` flag to automatically approve the execution without manual confirmation:
```
terraform apply --auto-approve
```

### Step 5: Explore the Provisioned Sandbox Projects
Once the Terraform apply process completes, you can explore the provisioned GCP sandbox projects in the Google Cloud Console. Experiment with the resources and services within these sandbox environments as needed.

### Additional Resources
- [Terraform Documentation](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
- [Google Cloud Documentation](https://cloud.google.com/docs)

That's it! You've successfully provisioned GCP sandbox projects using Terraform. Happy exploring!