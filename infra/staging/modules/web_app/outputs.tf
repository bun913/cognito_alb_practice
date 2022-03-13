output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service.id
}
output "ecs_task_exec_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}
