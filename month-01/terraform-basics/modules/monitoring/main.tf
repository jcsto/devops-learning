# ============================================================================
# MÓDULO DE MONITORING CON CLOUDWATCH
# ============================================================================
# Nota: SNS comentado porque el usuario test-asg no tiene permisos
# Para producción, habilitar SNS con permisos adecuados

# ============================================================================
# SNS TOPIC (comentado - requiere permisos SNS:CreateTopic)
# ============================================================================
# resource "aws_sns_topic" "alerts" {
#   name_prefix = "${var.project_name}-alerts-"
# }

# ============================================================================
# CLOUDWATCH DASHBOARD
# ============================================================================
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard-${var.environment}"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { stat = "Sum" }]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.name
          title  = "ALB Request Count"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "Average" }]
          ]
          period = 60
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "ALB Response Time (seconds)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "UnHealthyHostCount", { stat = "Average" }]
          ]
          period = 60
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "ALB Unhealthy Hosts"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "EC2 CPU Utilization (%)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "RDS CPU Utilization (%)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "FreeStorageSpace", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "RDS Free Storage (bytes)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "DatabaseConnections", { stat = "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "RDS Active Connections"
        }
      }
    ]
  })
}

# ============================================================================
# CLOUDWATCH ALARMS (sin SNS actions por ahora)
# ============================================================================

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "${var.project_name}-ec2-cpu-high-${var.environment}"
  alarm_description   = "Alert when EC2 CPU is high (> ${var.cpu_threshold_high}%)"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold_high
  treat_missing_data  = "notBreaching"
  
  # SNS actions comentado - sin permisos
  # alarm_actions = [aws_sns_topic.alerts.arn]
  
  tags = merge(var.tags, { Name = "EC2 High CPU" })
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_low" {
  alarm_name          = "${var.project_name}-ec2-cpu-low-${var.environment}"
  alarm_description   = "Alert when EC2 CPU is low (< ${var.cpu_threshold_low}%)"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold_low
  treat_missing_data  = "notBreaching"
  
  tags = merge(var.tags, { Name = "EC2 Low CPU" })
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.project_name}-rds-cpu-high-${var.environment}"
  alarm_description   = "Alert when RDS CPU is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"
  
  tags = merge(var.tags, { Name = "RDS High CPU" })
}

resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "${var.project_name}-rds-storage-low-${var.environment}"
  alarm_description   = "Alert when RDS storage is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.db_free_storage_threshold
  treat_missing_data  = "notBreaching"
  
  tags = merge(var.tags, { Name = "RDS Low Storage" })
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${var.project_name}-alb-unhealthy-${var.environment}"
  alarm_description   = "Alert when ALB has unhealthy hosts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.alb_unhealthy_threshold
  treat_missing_data  = "notBreaching"
  
  tags = merge(var.tags, { Name = "ALB Unhealthy Hosts" })
}

resource "aws_cloudwatch_metric_alarm" "alb_response_time" {
  alarm_name          = "${var.project_name}-alb-response-time-${var.environment}"
  alarm_description   = "Alert when ALB response time is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.alb_response_time_threshold
  treat_missing_data  = "notBreaching"
  
  tags = merge(var.tags, { Name = "ALB High Response Time" })
}

data "aws_region" "current" {}
