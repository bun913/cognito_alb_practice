resource "aws_ecs_cluster" "app" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags

  depends_on = [
    aws_lb.app
  ]
}

resource "aws_ecs_cluster_capacity_providers" "app" {
  cluster_name = aws_ecs_cluster.app.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

resource "aws_ecs_service" "app" {
  name    = "${var.prefix}-service"
  cluster = aws_ecs_cluster.app.id
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  platform_version = "1.4.0"
  task_definition  = aws_ecs_task_definition.app.arn
  # TODO: 起動数等は要件に応じて調整する
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.app_blue.arn
    container_name   = "color"
    container_port   = 8080
  }

  deployment_controller {
    type = "ECS"
  }

  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_service.id
    ]
    subnets = var.private_subnets
  }

  # ECS Exec用
  enable_execute_command = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      /* task_definition, */
      /* network_configuration, */
      /* launch_type, */
      /* platform_version, */
      /* capacity_provider_strategy */
    ]
  }

}
