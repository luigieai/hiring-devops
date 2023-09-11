data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.10.0"

  instance_type              = "t3.micro"
  use_mixed_instances_policy = false
  mixed_instances_policy     = {}
  user_data                  = filebase64("${path.module}/user_data.tpl")

  name = "hiring-devops"

  image_id = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]

  security_groups                 = var.security_groups_id
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true
  iam_role_name               = "hiring-devops-iam"
  iam_role_description        = "ECS role for hiring-devops"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonEC2ContainerRegistryReadOnly  = data.aws_iam_policy.ecr_access.arn
  }

  vpc_zone_identifier = var.subnet_ids
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in = false
}

resource "aws_ecs_capacity_provider" "this" {
  name = "hiring-devops"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.autoscaling.autoscaling_group_arn
    # When you use managed termination protection, you must also use managed scaling otherwise managed termination protection won't work
    managed_termination_protection = "DISABLED"

  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = "hiring-devops"
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  depends_on = [
    aws_ecs_capacity_provider.this
  ]
}
