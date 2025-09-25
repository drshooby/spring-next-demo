# Infrastructure

This directory contains infrastructure configuration and deployment scripts for AWS EC2.

## Overview

The infrastructure setup provides a production-ready environment for the Spring Next Demo application on AWS EC2, featuring:

- Containerized deployment using Docker
- Load balancing and auto-scaling capabilities
- Secure network configuration
- Monitoring and logging integration
- CI/CD pipeline configuration

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS Cloud                            │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                      VPC                                │ │
│  │  ┌──────────────┐                    ┌──────────────┐   │ │
│  │  │    Public    │                    │   Private    │   │ │
│  │  │   Subnet     │                    │   Subnet     │   │ │
│  │  │              │                    │              │   │ │
│  │  │ ┌──────────┐ │                    │ ┌──────────┐ │   │ │
│  │  │ │   ALB    │ │                    │ │   RDS    │ │   │ │
│  │  │ └──────────┘ │                    │ └──────────┘ │   │ │
│  │  │              │                    │              │   │ │
│  │  │ ┌──────────┐ │                    │              │   │ │
│  │  │ │ EC2 Auto │ │                    │              │   │ │
│  │  │ │ Scaling  │ │                    │              │   │ │
│  │  │ │  Group   │ │                    │              │   │ │
│  │  │ └──────────┘ │                    │              │   │ │
│  │  └──────────────┘                    └──────────────┘   │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┐
```

## Components

### AWS Services Used
- **EC2**: Virtual machines for application hosting
- **Application Load Balancer (ALB)**: Traffic distribution and SSL termination
- **Auto Scaling Groups**: Automatic scaling based on demand
- **RDS**: Managed database service
- **VPC**: Isolated network environment
- **Security Groups**: Network access control
- **IAM**: Identity and access management
- **CloudWatch**: Monitoring and logging
- **ECR**: Container registry (optional)

### Infrastructure Configuration Files

```
infra/
├── terraform/                  # Infrastructure as Code
│   ├── main.tf                # Main Terraform configuration
│   ├── variables.tf           # Input variables
│   ├── outputs.tf             # Output values
│   └── modules/               # Reusable modules
│       ├── networking/
│       ├── compute/
│       └── database/
├── docker-compose.prod.yml    # Production Docker Compose
├── scripts/                   # Deployment scripts
│   ├── deploy.sh             # Main deployment script
│   ├── setup.sh              # Initial environment setup
│   └── rollback.sh           # Rollback script
├── config/                    # Configuration files
│   ├── nginx.conf            # Reverse proxy configuration
│   └── docker/               # Docker configurations
└── README.md                 # This file
```

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 1.0+)
- Docker and Docker Compose
- SSH key pair for EC2 access

## Setup Instructions

### 1. Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and region
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Plan Infrastructure

```bash
# Review the planned infrastructure changes
terraform plan -var-file="prod.tfvars"
```

### 4. Deploy Infrastructure

```bash
# Apply the Terraform configuration
terraform apply -var-file="prod.tfvars"
```

### 5. Deploy Application

```bash
# Run the deployment script
./scripts/deploy.sh
```

## Environment Configuration

### Production Variables (`prod.tfvars`)

```hcl
# General Configuration
environment = "production"
project_name = "spring-next-demo"
region = "us-west-2"

# Networking
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b"]

# Compute
instance_type = "t3.medium"
min_size = 2
max_size = 10
desired_capacity = 3

# Database
db_instance_class = "db.t3.micro"
db_name = "springnextdemo"
db_username = "admin"
# db_password is set via environment variable

# Domain and SSL
domain_name = "your-domain.com"
certificate_arn = "arn:aws:acm:us-west-2:123456789:certificate/xxx"
```

## Deployment Process

### Automated Deployment

The deployment process includes:

1. **Build Phase**
   - Build Docker images for client and server
   - Run tests and security scans
   - Push images to container registry

2. **Infrastructure Phase**
   - Update infrastructure using Terraform
   - Configure security groups and networking
   - Set up monitoring and logging

3. **Application Phase**
   - Deploy containers to EC2 instances
   - Configure load balancer health checks
   - Update DNS records

### Manual Deployment Steps

```bash
# 1. Build and tag Docker images
docker build -t spring-next-demo-client ./client
docker build -t spring-next-demo-server ./server

# 2. Deploy to EC2 instances
./scripts/deploy.sh production

# 3. Verify deployment
./scripts/health-check.sh
```

## Monitoring and Logging

### CloudWatch Integration
- Application logs from containers
- EC2 instance metrics
- Load balancer metrics
- Custom application metrics

### Monitoring Dashboards
- Application performance metrics
- Infrastructure health status
- Error rates and response times
- Resource utilization

## Security Configuration

### Network Security
- Private subnets for database and internal services
- Security groups with minimal required access
- Network ACLs for additional layer security

### Application Security
- SSL/TLS termination at load balancer
- Secure secrets management
- Regular security updates and patching

## Scaling and Performance

### Auto Scaling Configuration
- CPU-based scaling policies
- Memory-based scaling policies
- Custom metrics scaling (e.g., request count)

### Performance Optimization
- Container resource limits and requests
- Database connection pooling
- CDN for static assets
- Caching strategies

## Backup and Recovery

### Database Backups
- Automated RDS snapshots
- Point-in-time recovery capability
- Cross-region backup replication

### Application Backups
- Container image versioning
- Configuration backup
- Infrastructure state backup

## Troubleshooting

### Common Issues
- Container startup failures
- Database connectivity issues
- Load balancer health check failures
- SSL certificate problems

### Debugging Commands

```bash
# Check EC2 instance status
aws ec2 describe-instances --filters "Name=tag:Project,Values=spring-next-demo"

# View container logs
docker logs [container-id]

# Check load balancer health
aws elbv2 describe-target-health --target-group-arn [target-group-arn]

# Monitor CloudWatch logs
aws logs tail /aws/ec2/spring-next-demo --follow
```

## Cost Management

### Cost Optimization
- Right-sizing EC2 instances
- Reserved instances for predictable workloads
- Spot instances for development environments
- Automated resource cleanup

### Cost Monitoring
- AWS Cost Explorer integration
- Budget alerts and notifications
- Resource tagging for cost allocation

## Maintenance

### Regular Tasks
- Security updates and patches
- Database maintenance windows
- SSL certificate renewals
- Performance monitoring and optimization

### Scheduled Maintenance Scripts
```bash
# Weekly security updates
./scripts/security-update.sh

# Monthly performance review
./scripts/performance-review.sh

# Quarterly cost analysis
./scripts/cost-analysis.sh
```