output "db_instance_identifier" {
  description = "Database instance identifier"
  value       = aws_db_instance.main.identifier
}

output "db_instance_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "Database address"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "Database port"
  value       = aws_db_instance.main.port
}

output "db_instance_arn" {
  description = "Database instance ARN"
  value       = aws_db_instance.main.arn
}

output "db_subnet_group_id" {
  description = "DB Subnet Group ID"
  value       = aws_db_subnet_group.main.id
}

output "db_instance_resource_id" {
  description = "Database resource ID"
  value       = aws_db_instance.main.resource_id
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Database master username"
  value       = var.db_username
  sensitive   = true
}

output "connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${var.db_username}:****@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${var.db_name}"
  sensitive   = true
}

