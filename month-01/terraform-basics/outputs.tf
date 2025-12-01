# ============================================================================
# OUTPUTS GLOBALES - RAÍZ DEL PROYECTO
# ============================================================================

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

# Monitoring Outputs
output "dashboard_url" {
  description = "CloudWatch Dashboard URL"
  value       = module.monitoring.dashboard_url
}

output "alarms_created" {
  description = "Number of CloudWatch alarms created"
  value       = module.monitoring.alarms_created
}

# Disaster Recovery Outputs
output "dr_runbook_path" {
  description = "Path to Disaster Recovery Runbook"
  value       = try(module.disaster_recovery.dr_runbook_path, "N/A - RDS module required")
}

output "multi_az_enabled" {
  description = "RDS Multi-AZ failover status"
  value       = try(module.disaster_recovery.multi_az_enabled, "N/A")
}

output "backup_retention_days" {
  description = "Automated backup retention period"
  value       = try(module.disaster_recovery.backup_retention_days, 0)
}
