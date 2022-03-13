resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.prefix}-app"
  tags              = var.tags
  retention_in_days = 90
}
