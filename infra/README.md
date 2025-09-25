# Infrastructure

AWS EC2 deployment configuration.

## Setup

```bash
aws configure
cd terraform
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
./scripts/deploy.sh
```

## Configuration

Create `prod.tfvars`:

```hcl
environment = "production"
project_name = "spring-next-demo"
region = "us-west-2"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b"]
instance_type = "t3.medium"
min_size = 2
max_size = 10
desired_capacity = 3
db_instance_class = "db.t3.micro"
db_name = "springnextdemo"
db_username = "admin"
domain_name = "your-domain.com"
certificate_arn = "arn:aws:acm:us-west-2:123456789:certificate/xxx"
```

## Deployment

```bash
# Build images
docker build -t spring-next-demo-client ./client
docker build -t spring-next-demo-server ./server

# Deploy to EC2
./scripts/deploy.sh production

# Health check
./scripts/health-check.sh
```