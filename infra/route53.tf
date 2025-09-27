resource "aws_route53_zone" "main" {
  name = "ettukube.com"

  tags = {
    Name = "ettukube.com"
  }
}

resource "aws_route53_record" "test" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "test.ettukube.com"
  type    = "A"
  ttl     = 120
  records = [aws_instance.server.public_ip]
}
