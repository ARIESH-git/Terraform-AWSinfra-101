# VPC Outputs
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

# Security Group Outputs
output "bastion_sg_id" {
  description = "ID of the Bastion security group"
  value       = module.security_group.bastion_sg_id
}

output "private_sg_id" {
  description = "ID of the Private instances security group"
  value       = module.security_group.private_sg_id
}

output "public_web_sg_id" {
  description = "ID of the Public Web (ALB) security group"
  value       = module.security_group.public_web_sg_id
}

# EC2 Instance Outputs
output "bastion_instance_id" {
  description = "ID of the Bastion instance"
  value       = module.instances.bastion_instance_id
}

output "bastion_private_ip" {
  description = "Private IP of the Bastion instance"
  value       = module.instances.bastion_private_ip
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion instance"
  value       = module.instances.bastion_public_ip
}

output "jenkins_instance_id" {
  description = "ID of the Jenkins instance"
  value       = module.instances.jenkins_instance_id
}

output "jenkins_private_ip" {
  description = "Private IP of the Jenkins instance"
  value       = module.instances.jenkins_private_ip
}

output "app_server_instance_id" {
  description = "ID of the App Server instance"
  value       = module.instances.app_server_instance_id
}

output "app_server_private_ip" {
  description = "Private IP of the App Server instance"
  value       = module.instances.app_server_private_ip
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = module.alb.alb_zone_id
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = module.alb.alb_security_group_id
}

output "main_target_group_arn" {
  description = "ARN of the main target group"
  value       = module.alb.main_target_group_arn
}

output "main_target_group_name" {
  description = "Name of the main target group"
  value       = module.alb.main_target_group_name
}

output "jenkins_target_group_arn" {
  description = "ARN of the Jenkins target group"
  value       = module.alb.jenkins_target_group_arn
}

output "jenkins_target_group_name" {
  description = "Name of the Jenkins target group"
  value       = module.alb.jenkins_target_group_name
}
