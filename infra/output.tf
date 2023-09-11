
output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "aws_region" {
  value = "us-east-2"
}

output "ecs_task_execution_role_arn" {
  value = module.ecs.ecs_task_execution_role_arn
}

output "ECS_Service" {
  value = module.ecs.ECS_Service
}

output "ECS_Cluster" {
  value = module.ecs.ECS_Cluster
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}