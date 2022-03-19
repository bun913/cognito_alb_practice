output "user_pool_arn" {
  value = aws_cognito_user_pool.main.arn
}
output "cognito_client_id" {
  value = aws_cognito_user_pool_client.main.id
}
output "cognito_domain" {
  value = aws_cognito_user_pool_domain.main.domain
}
output "congnito_domain_cname_value" {
  value = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
}
