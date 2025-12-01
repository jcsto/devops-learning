output "dashboard_url" {
  description = "CloudWatch Dashboard URL"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.name}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "alarms_created" {
  description = "Number of CloudWatch alarms created"
  value       = 6
}
