variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  description = "Public subnet ID for Bastion host"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for private instances"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "Security group ID for Bastion host"
  type        = string
}

variable "private_sg_id" {
  description = "Security group ID for private instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}
