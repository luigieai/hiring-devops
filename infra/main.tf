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