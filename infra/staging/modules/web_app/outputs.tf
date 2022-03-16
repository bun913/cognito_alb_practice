output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service.id
}
output "ecs_task_exec_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}
output "alb_dns_name" {
  value = aws_lb.app.dns_name
}
output "alb_zone_id" {
  value = aws_lb.app.zone_id
}
