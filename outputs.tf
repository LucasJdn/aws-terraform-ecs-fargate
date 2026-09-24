output "vpc_id" {
  description = "ID from VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs from Public subnet"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs from Private subnet"
  value       = module.network.private_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecs.ecr_repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = module.ecs.cluster_name
}