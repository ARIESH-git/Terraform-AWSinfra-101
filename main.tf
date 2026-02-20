module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr_block

  depends_on = [module.vpc]
}

module "instances" {
  source = "./modules/instances"

  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  public_subnet_id    = module.vpc.public_subnets[0]
  private_subnet_ids  = module.vpc.private_subnets
  bastion_sg_id       = module.security_group.bastion_sg_id
  private_sg_id       = module.security_group.private_sg_id

  depends_on = [module.security_group]
}

module "alb" {
  source = "./modules/alb"

  alb_name                        = var.alb_name
  vpc_id                          = module.vpc.vpc_id
  public_subnet_ids               = module.vpc.public_subnets
  enable_deletion_protection      = var.enable_alb_deletion_protection
  target_group_name               = var.target_group_name
  jenkins_target_group_name       = var.jenkins_target_group_name
  target_port                     = 80
  target_protocol                 = "HTTP"
  target_type                     = "instance"
  health_check_healthy_threshold  = 2
  health_check_unhealthy_threshold = 2
  health_check_timeout            = 5
  health_check_interval           = 30
  health_check_path               = "/"
  health_check_matcher            = "200"
  listener_port                   = 80
  listener_protocol               = "HTTP"
  target_instance_ids             = [module.instances.app_server_instance_id]
  jenkins_instance_ids            = [module.instances.jenkins_instance_id]
  jenkins_security_group_id       = module.security_group.private_sg_id

  tags = var.tags

  depends_on = [module.instances]
}
