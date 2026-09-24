#----------------------------------------
# SECURITY GROUPS
#----------------------------------------

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

#----------------------------------------
# ALB SECURITY GROUP RULES
#----------------------------------------

resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  description       = "Allow inbound HTTP traffic from the internet"
  security_group_id = aws_security_group.SG_ALB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_task_egress" {
  description                  = "Allow outbound traffic from ALB to ECS tasks on port 8080"
  security_group_id            = aws_security_group.SG_ALB.id
  referenced_security_group_id = aws_security_group.SG_TASK.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

#----------------------------------------
# ECS TASK SECURITY GROUP RULES
#----------------------------------------

resource "aws_vpc_security_group_ingress_rule" "allow_alb_to_task" {
  description                  = "Allow inbound traffic from ALB on port 8080"
  security_group_id            = aws_security_group.SG_TASK.id
  referenced_security_group_id = aws_security_group.SG_ALB.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "task_all_egress" {
  description       = "Allow outbound traffic from ECS tasks for ECR, CloudWatch, and internet"
  security_group_id = aws_security_group.SG_TASK.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}