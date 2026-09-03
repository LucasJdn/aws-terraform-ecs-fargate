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


resource "aws_ecs_task_definition" "task_test" {
  family                   = "..."
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = "..."
      image     = "${aws_ecr_repository.jdn_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "..."
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}