# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_public_ips" {
  description = "List of public IPs of NAT Gateways"
  value       = module.vpc.nat_gateway_public_ips
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = module.vpc.availability_zones
}

# Security Groups Outputs
output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = module.security_groups.alb_security_group_id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = module.security_groups.ec2_security_group_id
}

output "rds_security_group_id" {
  description = "RDS Security Group ID"
  value       = module.security_groups.rds_security_group_id
}

output "lambda_security_group_id" {
  description = "Lambda Security Group ID"
  value       = module.security_groups.lambda_security_group_id
}

# ALB Outputs
output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "Target Group ARN"
  value       = module.alb.target_group_arn
}

# EC2 Outputs
output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.ec2.asg_name
}

output "asg_arn" {
  description = "Auto Scaling Group ARN"
  value       = module.ec2.asg_arn
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.ec2.launch_template_id
}

output "ami_id" {
  description = "AMI ID used"
  value       = module.ec2.ami_id
}

# RDS Outputs
output "db_instance_endpoint" {
  description = "RDS Database endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "RDS Database address"
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "RDS Database port"
  value       = module.rds.db_instance_port
}

output "db_name" {
  description = "RDS Database name"
  value       = module.rds.db_name
}

