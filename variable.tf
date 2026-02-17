variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# VPC Variables
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway across all AZs"
  type        = bool
  default     = true
}

# EC2 Variables
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

# ALB Variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the main target group"
  type        = string
}

variable "jenkins_target_group_name" {
  description = "Name of the Jenkins target group"
  type        = string
}

variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

# Common Tags
variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
