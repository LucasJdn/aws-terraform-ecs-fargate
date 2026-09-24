variable "aws_region" {
  description = "AWS region for CloudWatch logs"
  type        = string
  default     = "us-east-1"
}

variable "log_retention_in_days" {
  description = "Retention period in days for CloudWatch log events"
  type        = number
  default     = 7
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "task_security_group_id" {
  description = "Security Group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN for ECS service load balancer association"
  type        = string
}

variable "desired_count" {
  description = "Desired number of running tasks for ECS service"
  type        = number
  default     = 1
}
