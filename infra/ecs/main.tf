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

resource "aws_ecs_capacity_provider" "test" {
  name = "hiring-devops"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.failure_analysis_ecs_asg.arn
    managed_termination_protection = "DISABLED"
  }
}
resource "aws_ecs_task_definition" "dummy" {
  family                = "hiring-devops"
  memory = "512"
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "hiring-devops",
    "image": ":latest",
    "essential": true,
    "portMappings": [{
      "containerPort": 22,
      "hostPort": 0
    }]
  }
]
TASK_DEFINITION
}

resource "aws_ecs_service" "service" {
  name            = "hiring-devops"
  cluster         = aws_ecs_cluster.hiring_devops.id
  task_definition = aws_ecs_task_definition.dummy.arn
  desired_count   = 1
}
