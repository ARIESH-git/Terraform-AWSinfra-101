output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = module.vpc.natgw_ids
}

output "private_route_table_ids" {
  description = "IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
  description = "IDs of public route tables"
  value       = module.vpc.public_route_table_ids
}
