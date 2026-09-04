resource "aws_security_group" "SG_ALB" {
  name        = "jdn-alb-sg"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG-ALB"
  }
}

resource "aws_security_group" "SG_TASK" {
  name        = "jdn-task-sg"
  description = "Security Group for ECS Task"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG-TASK"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_to_task" {
  security_group_id            = aws_security_group.SG_TASK.id
  referenced_security_group_id = aws_security_group.SG_ALB.id

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}