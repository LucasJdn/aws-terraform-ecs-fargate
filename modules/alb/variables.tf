variable "vpc_id" {
  description = "VPC ID where the Target Group is created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  type        = string
}
