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
  family                = "hiring-devops"
  cpu = 256
  memory = 512
  task_role_arn = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  
  container_definitions = <<DEFINITION
[
  {
    "name": "hiring-devops",
    "image": "alpine:latest",
    "essential": true
  }
]
DEFINITION

}

resource "aws_ecs_service" "service" {
  name            = "hiring-devops"
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.subnet_ids
    security_groups = var.security_groups_id
  }
  cluster         = aws_ecs_cluster.hiring_devops.id
  task_definition = aws_ecs_task_definition.dummy.arn
  desired_count   = 1
  //iam_role = aws_iam_role.ecsServiceRole.arn

  lifecycle {
    ignore_changes = [task_definition]
  }
}
