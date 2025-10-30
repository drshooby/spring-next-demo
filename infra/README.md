# Simple AWS EC2 Deployment with Terraform

This project demonstrates how to use **Infrastructure as Code (IaC)** to provision a simple AWS environment with **Terraform**.  
It creates a small virtual network (VPC), launches an EC2 instance, configures network security rules, and sets up a DNS record in Route 53 — all from code.

---

## Overview

### What this deployment creates

1. **VPC (Virtual Private Cloud)** — an isolated AWS network with public and private subnets.
2. **Security Groups** — network firewalls that:
   - Allow outbound internet traffic for OS updates.
   - Restrict SSH access to _your IP address only_.
   - Allow inbound HTTP/HTTPS traffic for web access.
3. **EC2 Instance** — a small virtual machine running in the public subnet.
4. **Route 53 Record** — creates a DNS `A` record (`cs601f.ettukube.com`) that points to the EC2 instance’s public IP.

## Variables

### Required

| Variable         | Description                                                          | Example              |
| ---------------- | -------------------------------------------------------------------- | -------------------- |
| `my_ip`          | Your public IP address in CIDR format (used to restrict SSH access). | `"203.0.113.25/32"`  |
| `hosted_zone_id` | The ID of your existing Route 53 hosted zone.                        | `"Z0123456789ABCDE"` |

### Optional (preconfigured with defaults)

| Variable               | Description                                             | Default                          |
| ---------------------- | ------------------------------------------------------- | -------------------------------- |
| `aws_region`           | AWS region for deployment.                              | `"us-east-1"`                    |
| `vpc_name`             | Name of the VPC.                                        | `"server-vpc"`                   |
| `vpc_cidr`             | CIDR block for the VPC.                                 | `"10.0.0.0/16"`                  |
| `aws_azs`              | List of availability zones to use.                      | `["us-east-1a"]`                 |
| `public_subnet_cidrs`  | CIDR blocks for public subnets.                         | `["10.0.1.0/24"]`                |
| `private_subnet_cidrs` | CIDR blocks for private subnets.                        | `["10.0.101.0/24"]`              |
| `ec2_config`           | EC2 configuration object (AMI, type, storage, SSH key). | See `variables.tf` for defaults. |

---

## Outputs

| Output          | Description                                        |
| --------------- | -------------------------------------------------- |
| `ec2_public_ip` | The public IP address of the created EC2 instance. |

---

## How to Use

### Deployment

1. Create a `terraform.tfvars` file with the following variables:

```bash
# replace with your values
# you can find your IP by visiting https://www.whatsmyip.org/
my_ip         = "123.456.789.0/32"
hosted_zone_id = "Z0123456789ABCDE"
```

2. Initalize the backend with `terraform init` to configure terraform.
3. Validate syntax with `terraform validate`.
4. Preview changes with `terraform plan`.
5. Apply the changes with `terraform apply` and choose `yes`.
6. Wait for Terraform to provision and at the end retrieve `ec2_public_ip` (this can be used to SSH into your instance, if you want)
7. Run `scripts/easy_deploy` and that's it!

### Deprovision Infrastructure

Infrastructure isn't free (or necessarily cheap), run `terraform destroy` and choose `yes`.
