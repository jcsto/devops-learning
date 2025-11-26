# Main orchestration file for modules
# Will add module calls here
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  environment           = var.environment
  project_name          = var.project_name
  enable_nat_gateway    = var.enable_nat_gateway
  single_nat_gateway    = var.single_nat_gateway
  enable_vpn_gateway    = var.enable_vpn_gateway
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = var.tags
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  environment  = var.environment
  project_name = var.project_name

  tags = var.tags
}

# Placeholder para ALB (necesario para EC2)
# Nota: ALB se debe crear primero para obtener target_group_arn
# Por ahora usamos un valor dummy, luego actualizaremos
module "ec2" {
  source = "./modules/ec2"

  environment          = var.environment
  project_name         = var.project_name
  instance_type        = "t3.micro"
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_id    = module.security_groups.ec2_security_group_id
  target_group_arn     = "" # Actualizar después de crear ALB

  tags = var.tags

  depends_on = [module.security_groups]
}

