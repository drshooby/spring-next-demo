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
