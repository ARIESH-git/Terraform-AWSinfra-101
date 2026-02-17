# Bastion Host (Public Subnet)
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

# Jenkins Host (Private Subnet)
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name

  associate_public_ip_address = false

  tags = {
    Name = "jenkins-host"
  }
}

# App Host (Private Subnet)
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[1]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name

  associate_public_ip_address = false

  tags = {
    Name = "app-host"
  }
}
