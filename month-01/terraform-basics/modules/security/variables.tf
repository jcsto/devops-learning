# ============================================================================
# VARIABLES - SECURITY MODULE
# ============================================================================

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for flow logs"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint for secrets"
  type        = string
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
