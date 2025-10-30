/**
* route53.tf
* ----------------------------
* Purpose:
*   This Terraform file adds a DNS record to an existing Route 53 hosted zone.
*   It links a public domain record (cs601f.ettukube.com) to the EC2 instance’s
*   public IP address, making it accessible by name instead of by IP.
*
* What it does:
*   - References an existing Route 53 hosted zone using the variable `hosted_zone_id`.
*   - Creates an A record (cs601f.ettukube.com) that points to the EC2 instance.
*   - Uses a short TTL (120 seconds) to allow DNS updates to propagate quickly.
*/

resource "aws_route53_record" "cs601f" {
  zone_id = var.hosted_zone_id
  name    = "cs601f.ettukube.com"
  type    = "A"
  ttl     = 120
  records = [aws_instance.server.public_ip]
}
