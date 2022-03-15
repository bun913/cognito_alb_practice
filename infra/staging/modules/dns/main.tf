resource "aws_route53_zone" "main" {
  name = var.root_domain
  tags = var.tags
}
