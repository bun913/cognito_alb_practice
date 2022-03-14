output "acm_arn" {
  value = aws_acm_certificate.cert.arn
}
output "acm_sub_arn" {
  value = aws_acm_certificate.cert_sub.arn
}
