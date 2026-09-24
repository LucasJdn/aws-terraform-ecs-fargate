output "alb_security_group_id" {
  description = "ID of the Security Group for the ALB"
  value       = aws_security_group.SG_ALB.id
}

output "task_security_group_id" {
  description = "ID of the Security Group for the ECS Task"
  value       = aws_security_group.SG_TASK.id
}
