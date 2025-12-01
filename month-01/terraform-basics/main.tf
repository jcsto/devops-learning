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

module "alb" {
  source = "./modules/alb"

  environment          = var.environment
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnet_ids
  security_group_id    = module.security_groups.alb_security_group_id
  enable_http2         = true
  health_check_path    = "/"
  health_check_port    = "8080"
  target_port          = 8080

  tags = var.tags

  depends_on = [module.security_groups]
}

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
  target_group_arn     = module.alb.target_group_arn

  tags = var.tags

  depends_on = [module.alb]
}

module "rds" {
  source = "./modules/rds"

  environment          = var.environment
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_id    = module.security_groups.rds_security_group_id
  allocated_storage    = 20
  engine_version = "16.6"
  instance_class       = "db.t3.micro"
  db_name              = "appdb"
  db_username          = "postgres"
  db_password          = "TempPassword123!" # IMPORTANTE: Cambiar en producción
  backup_retention_period = 7
  multi_az             = true

  tags = var.tags

  depends_on = [module.security_groups]
}


module "monitoring" {
  source = "./modules/monitoring"

  environment       = var.environment
  project_name      = var.project_name
  alb_name          = module.alb.alb_dns_name
  asg_name          = module.ec2.asg_name
  db_instance_id    = "devops-platform-db-20251126040314138900000001"  # Del tfstate
  
  # Opcional: email para alertas
  alarm_email       = ""
  
  tags = var.tags

  depends_on = [module.alb, module.ec2]
}
