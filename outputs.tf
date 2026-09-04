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