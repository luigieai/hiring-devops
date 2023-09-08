terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ecs_cluster" "hiring-devops" {
  name = "hiring-devops"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}