output "public_ip" {
  value = aws_instance.server.public_ip
}

# For registrar
output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}
