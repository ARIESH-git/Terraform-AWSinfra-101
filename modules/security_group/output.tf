output "bastion_sg_id" {
  description = "ID of the Bastion security group"
  value       = aws_security_group.bastion_sg.id
}

output "private_sg_id" {
  description = "ID of the Private instances security group"
  value       = aws_security_group.private_sg.id
}

output "public_web_sg_id" {
  description = "ID of the Public Web (ALB) security group"
  value       = aws_security_group.public_web_sg.id
}
