# DevOps Demo - GCP Infrastructure with Terraform

This Terraform configuration deploys a complete infrastructure on Google Cloud Platform (GCP) including a VPC, subnets, and a web server running nginx with a sample DevOps page.

## 🏗️ Architecture

- **VPC**: Custom VPC network
- **Subnets**: 2 subnets in the eu-central region
- **VM Instance**: Ubuntu 22.04 LTS with nginx
- **Firewall Rules**: HTTP (80) and SSH (22) access
- **Web Server**: Nginx serving a custom DevOps HTML page

## 📋 Prerequisites

1. **Google Cloud Platform Account**
   - Active GCP project
   - Billing enabled

2. **Terraform Installed**
   ```bash
   # Check if Terraform is installed
   terraform --version
   
   # If not installed, download from: https://www.terraform.io/downloads
   ```

3. **Google Cloud SDK (gcloud)**
   ```bash
   # Check if gcloud is installed
   gcloud --version
   
   # If not installed, download from: https://cloud.google.com/sdk/docs/install
   ```

4. **Authentication**
   ```bash
   # Login to GCP
   gcloud auth login
   
   # Set your project
   gcloud config set project YOUR_PROJECT_ID
   
   # Create application default credentials
   gcloud auth application-default login
   ```

## 🚀 Quick Start

### Step 1: Clone or Download the Files

Ensure you have all these files in your working directory:
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `startup-script.sh`
- `terraform.tfvars.example`

### Step 2: Configure Variables

Create a `terraform.tfvars` file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set your project ID:

```hcl
project_id   = "your-gcp-project-id"
project_name = "devops-demo"
region       = "europe-central2"
zone         = "europe-central2-a"
```

### Step 3: Enable Required APIs

```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### Step 4: Initialize Terraform

```bash
terraform init
```

This will download the required GCP provider plugins.

### Step 5: Review the Plan

```bash
terraform plan
```

Review the resources that will be created.

### Step 6: Deploy the Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### Step 7: Access Your Web Server

After deployment completes (typically 2-3 minutes), Terraform will output the public IP:

```bash
# Get outputs
terraform output

# Or specifically get the web URL
terraform output web_url
```

Open the URL in your browser to see your DevOps page!

## 📊 Outputs

After successful deployment, you'll see:

```
vm_external_ip = "34.116.xxx.xxx"
web_url        = "http://34.116.xxx.xxx"
ssh_command    = "gcloud compute ssh devops-demo-web-server --zone=europe-central2-a"
```

## 🔐 SSH Access

To connect to your VM:

```bash
# Using gcloud (recommended)
gcloud compute ssh devops-demo-web-server --zone=europe-central2-a

# Or using the output command
terraform output -raw ssh_command | bash
```

## 🧪 Testing

1. **Test HTTP Access**:
   ```bash
   curl http://$(terraform output -raw vm_external_ip)
   ```

2. **Check Nginx Status**:
   ```bash
   gcloud compute ssh devops-demo-web-server --zone=europe-central2-a --command="sudo systemctl status nginx"
   ```

3. **View Startup Script Logs**:
   ```bash
   gcloud compute ssh devops-demo-web-server --zone=europe-central2-a --command="cat /var/log/startup-script.log"
   ```

## 🛠️ Customization

### Change VM Size

Edit `variables.tf` or set in `terraform.tfvars`:

```hcl
machine_type = "e2-medium"  # Options: e2-micro, e2-small, e2-medium, etc.
```

### Change Region/Zone

```hcl
region = "europe-west1"
zone   = "europe-west1-b"
```

Available EU regions:
- `europe-west1` - Belgium
- `europe-west2` - London
- `europe-west3` - Frankfurt
- `europe-central2` - Warsaw
- `europe-north1` - Finland

### Modify HTML Page

Edit the `startup-script.sh` file and customize the HTML content between the `cat > /var/www/html/index.html <<EOF` and `EOF` markers.

### Add SSH Key

Add your SSH public key to `terraform.tfvars`:

```hcl
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... your-email@example.com"
```

## 💰 Cost Estimation

Using `e2-micro` instance (Free Tier eligible):
- **VM**: ~$7-8/month (or free if within free tier limits)
- **Network Egress**: ~$0.12/GB (first 1GB free per month)
- **VPC**: Free

## 🧹 Cleanup

To destroy all resources and avoid charges:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

## 📁 File Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── startup-script.sh          # VM initialization script
├── terraform.tfvars.example   # Example variables file
└── README.md                  # This file
```

## 🔍 Troubleshooting

### Issue: "Error 403: Compute Engine API has not been used"

**Solution**: Enable the Compute Engine API:
```bash
gcloud services enable compute.googleapis.com
```

### Issue: "Permission denied" errors

**Solution**: Ensure you have proper IAM roles:
- Compute Admin (`roles/compute.admin`)
- Service Account User (`roles/iam.serviceAccountUser`)

```bash
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="user:YOUR_EMAIL" \
    --role="roles/compute.admin"
```

### Issue: Web page not loading

**Solution**: 
1. Wait 2-3 minutes for startup script to complete
2. Check firewall rules are applied
3. Check VM serial console output:
   ```bash
   gcloud compute instances get-serial-port-output devops-demo-web-server --zone=europe-central2-a
   ```

### Issue: Terraform state locked

**Solution**: 
```bash
terraform force-unlock LOCK_ID
```

## 📚 Resources

- [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Compute Engine Documentation](https://cloud.google.com/compute/docs)
- [GCP Regions and Zones](https://cloud.google.com/compute/docs/regions-zones)
- [GCP Free Tier](https://cloud.google.com/free)

## 🤝 Support

For issues:
1. Check the troubleshooting section above
2. Review GCP Console logs
3. Check Terraform state: `terraform show`

## 📝 License

This is a demo project for learning purposes.

---

**Happy DevOps! 🚀**
