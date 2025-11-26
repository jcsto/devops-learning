output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2.id
}

output "rds_security_group_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds.id
}

output "lambda_security_group_id" {
  description = "Lambda Security Group ID"
  value       = aws_security_group.lambda.id
}

output "alb_security_group_name" {
  description = "ALB Security Group Name"
  value       = aws_security_group.alb.name
}

output "ec2_security_group_name" {
  description = "EC2 Security Group Name"
  value       = aws_security_group.ec2.name
}

output "rds_security_group_name" {
  description = "RDS Security Group Name"
  value       = aws_security_group.rds.name
}

output "lambda_security_group_name" {
  description = "Lambda Security Group Name"
  value       = aws_security_group.lambda.name
}

