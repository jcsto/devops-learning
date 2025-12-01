output "dr_runbook_path" {
  description = "Path to Disaster Recovery Runbook"
  value       = local_file.dr_runbook.filename
}

output "dr_sla_path" {
  description = "Path to DR SLA document"
  value       = local_file.dr_sla.filename
}

output "multi_az_enabled" {
  description = "Multi-AZ failover status"
  value       = var.multi_az_enabled
}

output "backup_retention_days" {
  description = "Automated backup retention period"
  value       = var.backup_retention_days
}
