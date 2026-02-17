variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "target_group_name" {
  description = "Name of the main target group"
  type        = string
}

variable "target_port" {
  description = "Target port for the main target group"
  type        = number
  default     = 80
}

variable "target_protocol" {
  description = "Target protocol for the main target group"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Target type for the main target group"
  type        = string
  default     = "instance"
}

variable "health_check_healthy_threshold" {
  description = "Health check healthy threshold"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Health check unhealthy threshold"
  type        = number
  default     = 2
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Health check matcher"
  type        = string
  default     = "200"
}

variable "jenkins_target_group_name" {
  description = "Name of the Jenkins target group"
  type        = string
}

variable "listener_port" {
  description = "Listener port for ALB"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol for ALB"
  type        = string
  default     = "HTTP"
}

variable "target_instance_ids" {
  description = "List of target instance IDs for the main target group"
  type        = list(string)
  default     = []
}

variable "jenkins_instance_ids" {
  description = "List of Jenkins instance IDs"
  type        = list(string)
  default     = []
}

variable "jenkins_security_group_id" {
  description = "Security group ID of Jenkins instances"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
