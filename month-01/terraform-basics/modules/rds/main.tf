# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name_prefix = "dbsg-"
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-subnet-group-${var.environment}"
    }
  )
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier_prefix = "${var.project_name}-db-"

  engine               = "postgres"
  engine_version       = "16.6"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  max_allocated_storage = 100

  db_name  = "appdb"
  username = "postgres"
  password = "TempPassword123!"

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  # Backup Configuration
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Maintenance
  maintenance_window = var.maintenance_window

  # High Availability
  multi_az = var.multi_az

  # Encryption
  storage_encrypted = var.enable_storage_encryption

  # Monitoring
  enabled_cloudwatch_logs_exports = var.enable_cloudwatch_logs_exports
  monitoring_interval             = 60
  monitoring_role_arn             = aws_iam_role.rds_monitoring.arn

  # Performance
  performance_insights_enabled = true

  # Deletion Protection
  deletion_protection = var.environment == "prod" ? true : false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-${var.environment}"
    }
  )

  depends_on = [aws_iam_role_policy.rds_monitoring]
}

# IAM Role for RDS Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name_prefix = "${var.project_name}-rds-monitoring-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for RDS Monitoring
resource "aws_iam_role_policy" "rds_monitoring" {
  name_prefix = "${var.project_name}-rds-monitoring-policy-"
  role        = aws_iam_role.rds_monitoring.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutRetentionPolicy"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:log-group:/aws/rds/*"
      }
    ]
  })
}

# CloudWatch Alarm - Database CPU
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project_name}-rds-cpu-${var.environment}"
  alarm_description   = "Alert when RDS CPU is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.identifier
  }

  tags = var.tags
}

# CloudWatch Alarm - Database Storage
resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${var.project_name}-rds-storage-${var.environment}"
  alarm_description   = "Alert when RDS free storage is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 1073741824 # 1 GB in bytes

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.identifier
  }

  tags = var.tags
}

# CloudWatch Alarm - Database Connections
resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${var.project_name}-rds-connections-${var.environment}"
  alarm_description   = "Alert when RDS connections are high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.identifier
  }

  tags = var.tags
}

