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
}