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
