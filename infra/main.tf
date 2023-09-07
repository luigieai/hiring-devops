module "ecr" {
  source = "./ecr"
  providers = {
    aws = aws
  }
}