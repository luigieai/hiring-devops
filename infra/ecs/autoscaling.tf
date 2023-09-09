data "aws_ami" "ecs_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = data.aws_ami.ecs_ami.image_id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = var.security_groups_id
    user_data = base64encode(
<<EOF
#!/bin/bash
echo "ECS_CLUSTER=hiring-devops" >> /etc/ecs/ecs.config
EOF
  )
    instance_type        = "t2.micro"
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
    name                      = "hiring-devops-ecs-asg"
    vpc_zone_identifier       = var.subnet_ids
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 0
    max_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
    tag {
        key                 = "AmazonECSManaged"
        value               = true
        propagate_at_launch = true
  }
}