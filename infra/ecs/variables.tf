variable "security_groups_id" {
  type        = list(string)
  description = "Security groups that ECS deployments will use"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Ids of subnet that AutoscalingECS will be created"
}

variable "ecr_arn" {
  type        = string
  description = "ECR ARN for crating IAM policy"
}

variable "alb_targetgroup_arn" {
  type        = string
  description = "ALB Arn for ECS Service"
}