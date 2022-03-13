resource "aws_ecs_task_definition" "app" {
  family        = "${var.prefix}-task-def"
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = "512"
  cpu                = "256"
  container_definitions = templatefile(
    "${path.module}/taskdef/app.json",
    {
      ECR_REPO      = "${var.ecr_base_uri}/${var.tags.Project}-app"
      APP_LOG_GROUP = aws_cloudwatch_log_group.app.name
      REGION        = var.region
    }
  )
  tags = var.tags
}
