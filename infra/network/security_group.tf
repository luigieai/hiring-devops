resource "aws_security_group" "alb_sg" {
  name   = "hiring-devops-sg-alb"
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ecs_sg" {
  name   = "hiring-devops-sg-ecs"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 49153
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.alb_public_subnet_1.cidr_block, aws_subnet.alb_public_subnet_2.cidr_block]
  }

  ingress {
    from_port   = 32768
    to_port     = 61000
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.alb_public_subnet_1.cidr_block, aws_subnet.alb_public_subnet_2.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}