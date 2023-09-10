module "ecr" {
  source = "./ecr"
  providers = {
    aws = aws
  }
}

module "network" {
  source = "./network"
  providers = {
    aws = aws
  }
}

module "ecs" {
  source = "./ecs"
  providers = {
    aws = aws
  }
  security_groups_id = [module.network.ecs_subnet_sg_id]
  subnet_ids         = [module.network.ecs_subnet_id]
}

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