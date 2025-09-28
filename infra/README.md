# Infrastructure (infra/)

This directory contains Terraform configuration files for deploying the AWS infrastructure needed to host the spring-next-demo application on EC2.

## Overview

The infrastructure provisions:
- **VPC**: Virtual Private Cloud with public and private subnets
- **EC2 Instance**: Ubuntu server for hosting the Docker containers
- **Security Groups**: Firewall rules for HTTP/HTTPS traffic
- **Route53**: DNS management for your domain

## Dependencies

### Required Software
- **Terraform**: Download and install from [terraform.io](https://terraform.io/downloads)
  - Minimum version: 1.0+
  - Alternative: Use AWS CloudFormation or manually configure resources via AWS Console

### AWS Prerequisites  
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create VPC, EC2, Route53, and Security Group resources

## Files Overview

| File | Purpose |
|------|---------|
| `main.tf` | Main Terraform configuration and provider setup |
| `variables.tf` | Input variables for customization |
| `vpc.tf` | VPC, subnets, and networking configuration |
| `ec2.tf` | EC2 instance and related resources |
| `sg.tf` | Security Group rules for HTTP/HTTPS access |
| `route53.tf` | DNS zone and record configuration |
| `outputs.tf` | Important values needed for deployment |

## Usage Steps

### 1. Initialize Terraform
```bash
cd infra/
terraform init
```

### 2. Review and Customize Variables
Edit `variables.tf` or create a `terraform.tfvars` file to customize:
- AWS region
- Instance type
- Domain name
- VPC CIDR ranges

### 3. Plan Infrastructure
```bash
terraform plan
```

### 4. Deploy Infrastructure
```bash
terraform apply
```

### 5. **IMPORTANT: Configure Domain Registrar**
After deployment, you **MUST** configure your domain registrar with the Route53 nameservers:

```bash
# Get the nameservers from Terraform output
terraform output name_servers
```

Go to your domain registrar (GoDaddy, Namecheap, etc.) and:
1. Navigate to your domain's DNS management
2. Replace the default nameservers with the 4 AWS Route53 nameservers from the output above
3. Save the changes (DNS propagation can take up to 48 hours)

**Without this step, your domain will not point to your AWS infrastructure!**

### 6. Get Deployment Information
```bash
# Get the public IP for your EC2 instance
terraform output public_ip

# Get hosted zone ID (if needed)
terraform output hosted_zone_id
```

## Security Considerations

- The EC2 instance is configured with security groups that only allow:
  - HTTP (port 80) from anywhere
  - HTTPS (port 443) from anywhere  
  - SSH (port 22) from anywhere (consider restricting to your IP)

## Cost Considerations

This infrastructure includes:
- 1 EC2 instance (t3.micro eligible for free tier)
- 1 VPC with NAT Gateway (charges apply)
- Route53 hosted zone (~$0.50/month)

## Cleanup

To destroy all infrastructure:
```bash
terraform destroy
```

**Warning**: This will permanently delete all AWS resources created by this configuration.