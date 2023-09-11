output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "ecs_subnet_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_subnet_id" {
  value = aws_subnet.ecs_private_subnet.id
}

output "alb_subnet_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_subnet_1_id" {
  value = aws_subnet.alb_public_subnet_1.id
}

output "alb_subnet_2_id" {
  value = aws_subnet.alb_public_subnet_2.id
}