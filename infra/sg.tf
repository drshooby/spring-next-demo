/**
* security_groups.tf
* ----------------------------
* Purpose:
*   This Terraform file defines the security groups (firewall rules) used by the EC2 instance.
*   Each group controls specific types of network traffic into or out of the server.
*
* What it does:
*   - Allows the instance to connect to the internet for updates.
*   - Restricts SSH access to your IP only.
*   - Opens HTTP and HTTPS ports for web access.
*/


# ----------------------------
# Allows all outbound traffic (e.g., OS updates, package installs)
# ----------------------------
resource "aws_security_group" "outgoing_all" {
  name        = "outgoing to the internet"
  description = "security group that allows updates"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Receive updates"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ----------------------------
# Allows SSH access only from your IP address (for secure management)
# ----------------------------
resource "aws_security_group" "ssh_my_ip" {
  name        = "ssh from my ip"
  description = "security group that only allows ssh access through my ip"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
}


# ----------------------------
# Allows HTTP (port 80) and HTTPS (port 443) traffic from the internet
# for serving web content publicly
# ----------------------------
resource "aws_security_group" "server_http" {
  name        = "server access from the internet"
  description = "security group that allows http/s incoming connections from the internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
