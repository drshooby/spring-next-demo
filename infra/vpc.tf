/**
* vpc.tf
* ----------------------------
* Purpose:
*   This Terraform file sets up a Virtual Private Cloud (VPC) using the official
*   AWS VPC module. A VPC is a private network in AWS that you can control,
*   similar to your own data center network.
*
* What it does:
*   - Creates a VPC with both public and private subnets across multiple Availability Zones.
*   - Enables a single NAT Gateway so private subnets can access the internet securely.
*   - Defines the IP address ranges (CIDR blocks) for the network and its subnets.
*
* Notes:
*   - Public subnets can host resources that need internet access (e.g., web servers).
*   - Private subnets are for internal resources that should not be directly exposed.
*/

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = var.aws_azs
  private_subnets        = var.private_subnet_cidrs
  public_subnets         = var.public_subnet_cidrs
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
