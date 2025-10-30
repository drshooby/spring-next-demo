/**
* ec2.tf
* ----------------------------
* Purpose:
*   This Terraform file provisions an Amazon EC2 virtual machine (VM) instance
*   using Infrastructure as Code (IaC) to automate cloud resource setup
*   without needing to click through the AWS console.
*
* What it does:
*   - Creates a single EC2 instance using configuration values defined in variables (var.ec2_config).
*   - Attaches the instance to a public subnet in a VPC module.
*   - Applies multiple security groups for network access control.
*   - Allocates a root volume (disk) and tags the instance for identification.
*
* Security Group Rules (attached to this instance):
*   1. aws_security_group.ssh_my_ip
*      → Allows SSH access (port 22) *only* from your IP address.
*
*   2. aws_security_group.outgoing_all
*      → Allows the instance to send outbound traffic to any destination.
*
*   3. aws_security_group.server_http
*      → Allows inbound HTTP (port 80, later 443) traffic for web access.
*/

resource "aws_instance" "server" {
  instance_type = var.ec2_config.instance_type
  ami           = var.ec2_config.ami
  key_name      = var.ec2_config.ssh_key_name
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [
    aws_security_group.ssh_my_ip.id,
    aws_security_group.outgoing_all.id,
    aws_security_group.server_http.id
  ]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.ec2_config.storage_size
    volume_type           = var.ec2_config.storage_type
    delete_on_termination = true
  }

  tags = {
    Name = "machine"
  }
}
