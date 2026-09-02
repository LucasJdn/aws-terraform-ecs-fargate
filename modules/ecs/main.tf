resource "aws_ecr_repository" "jdn_repo"{
    name = "..."
    image_tag_mutability = "IMMUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}

resource "aws_iam_role" "execution_role"{
    name = "..."

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {Service = "ecs-tasks.amazonaws.com"}
        }]
    })
}

resource "aws_iam_role_policy_attachment" "execution_role_policy"{
    role = aws_iam_role.execution_role.name
    policy_arn = "arn:aws:iam:aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "task_role" {
  name = "..."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}