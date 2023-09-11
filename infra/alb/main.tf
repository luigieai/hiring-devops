terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_lb" "this" {
  name               = "hiring-devops-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_id
  subnets            = var.subnets_id
}

resource "aws_lb_target_group" "this" {
  name        = "hiring-devops-lb-alb-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path              = "/"
    healthy_threshold = 2
    interval          = 30
    protocol          = "HTTP"
    timeout           = 20
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}