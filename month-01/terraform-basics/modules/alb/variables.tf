variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB (should be public subnets)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type        = number
  default     = 60
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_port" {
  description = "Health check port"
  type        = string
  default     = "8080"
}

variable "health_check_interval_seconds" {
  description = "Health check interval"
  type        = number
  default     = 30
}

variable "health_check_timeout_seconds" {
  description = "Health check timeout"
  type        = number
  default     = 5
}

variable "healthy_threshold_count" {
  description = "Healthy threshold count"
  type        = number
  default     = 2
}

variable "unhealthy_threshold_count" {
  description = "Unhealthy threshold count"
  type        = number
  default     = 2
}

variable "target_port" {
  description = "Target port for instances"
  type        = number
  default     = 8080
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

