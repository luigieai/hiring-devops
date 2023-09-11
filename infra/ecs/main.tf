terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ecs_cluster" "hiring_devops" {
  name = "hiring-devops"

}
resource "aws_ecs_task_definition" "dummy" {
  family             = "hiring-devops"
  cpu                = 256
  memory             = 512
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "hiring-devops",
    "image": "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50",
    "essential": true,
    "portMappings": [{
      "containerPort": 80,
      "hostPort": 80
    }]
  }
]
DEFINITION

}

resource "aws_ecs_service" "service" {
  name        = "hiring-devops"
  launch_type = "EC2"
  cluster         = aws_ecs_cluster.hiring_devops.id
  task_definition = aws_ecs_task_definition.dummy.arn
  desired_count   = 1

  //  lifecycle {
  //    ignore_changes = [task_definition]
  //  }
}
