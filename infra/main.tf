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