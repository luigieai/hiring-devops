data "aws_iam_policy" "ecr_access" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "hiring-devops-task_execution_role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-s3" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecr_access.arn
}
resource "aws_iam_role" "ecs_task_role" {
  name = "hiring-devops-task_role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

