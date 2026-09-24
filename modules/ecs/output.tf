output "cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.cluster.name
}

output "cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = aws_ecs_cluster.cluster.arn
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.jdn_repo.repository_url
}

output "task_definition_arn" {
  description = "ARN of the Task Definition"
  value       = aws_ecs_task_definition.task_test.arn
}

output "service_id" {
  description = "ID of the ECS Service"
  value       = aws_ecs_service.service.id
}

output "service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.service.name
}