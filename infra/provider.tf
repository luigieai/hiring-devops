terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket     = "hiringdevops-terraform"
    key        = "infra/hiring-devops"
    region     = "us-east-2"
  }
}

provider "aws" {
  region     = "us-east-2"
}