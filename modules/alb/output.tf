output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb_sg.id
}

output "main_target_group_arn" {
  description = "ARN of the main target group"
  value       = aws_lb_target_group.main.arn
}

output "main_target_group_name" {
  description = "Name of the main target group"
  value       = aws_lb_target_group.main.name
}

output "jenkins_target_group_arn" {
  description = "ARN of the Jenkins target group"
  value       = aws_lb_target_group.jenkins.arn
}

output "jenkins_target_group_name" {
  description = "Name of the Jenkins target group"
  value       = aws_lb_target_group.jenkins.name
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.main.arn
}
