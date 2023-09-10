output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ECS_Service" {
  value = aws_ecs_service.service.name
}

output "ECS_Cluster" {
  value = aws_ecs_cluster.hiring_devops.name
}