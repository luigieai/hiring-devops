terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    tags       = {
        Name = "Hiring Devops VPC"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "main_subnet" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
}

resource "aws_subnet" "ecs_subnet" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}
