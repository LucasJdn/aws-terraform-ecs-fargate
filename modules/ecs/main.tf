#----------------------------------------
# REPOSITORY
#----------------------------------------

resource "aws_ecr_repository" "jdn_repo" {
  name                 = "jdn-ecs-app"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "jdn_repo_policy" {
  repository = aws_ecr_repository.jdn_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

#----------------------------------------
# IAM
#----------------------------------------

resource "aws_iam_role" "execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

#----------------------------------------
# TASKS
#----------------------------------------

resource "aws_ecs_task_definition" "task_test" {
  family                   = "jdn-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name      = "jdn-ecs-app"
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
          "awslogs-group"         = "Project04"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}


#----------------------------------------
# CLOUDWATCH
#----------------------------------------

resource "aws_cloudwatch_log_group" "project04" {
  name              = "Project04"
  retention_in_days = var.log_retention_in_days

  tags = {
    Name        = "Project04"
    Environment = "production"
  }
}

#----------------------------------------
# CLUSTER
#----------------------------------------

resource "aws_ecs_cluster" "cluster" {
  name = "jdn-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "jdn-ecs-cluster"
    Environment = "production"
  }
}

#----------------------------------------
# SERVICE
#----------------------------------------

resource "aws_ecs_service" "service" {
  name            = "jdn-ecs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_test.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.task_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "jdn-ecs-app"
    container_port   = 8080
  }

  tags = {
    Name        = "jdn-ecs-service"
    Environment = "production"
  }
}