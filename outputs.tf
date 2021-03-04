output "ecs_service" {
  value = aws_ecs_service.service
}

output "security_group" {
  value = aws_security_group.ecs_sg
}