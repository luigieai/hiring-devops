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

module "alb" {
  source = "./alb"
  providers = {
    aws = aws
  }
  vpc_id             = module.network.vpc_id
  security_groups_id = [module.network.alb_subnet_sg_id]
  subnets_id         = [module.network.alb_subnet_1_id, module.network.alb_subnet_2_id]
}

module "ecs" {
  source = "./ecs"
  providers = {
    aws = aws
  }
  security_groups_id  = [module.network.ecs_subnet_sg_id]
  subnet_ids          = [module.network.ecs_subnet_id]
  ecr_arn             = module.ecr.ecr_arn
  alb_targetgroup_arn = module.alb.target_group_arn
}