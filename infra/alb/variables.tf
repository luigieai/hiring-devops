variable "vpc_id" {
  type        = string
  description = "VPC ID for ALB target group"
}

variable "security_groups_id" {
  type        = list(string)
  description = "List of vpc security groups for the ALB"
}

variable "subnets_id" {
  type        = list(string)
  description = "List of subnets IDS for the ALB"
}