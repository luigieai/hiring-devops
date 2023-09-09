output "ecs_subnet_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_subnet_id" {
  value = aws_subnet.ecs_subnet.id
}