# ============================================================================
# VARIABLES PARA EL MÓDULO DE MONITORING
# ============================================================================
# Estas variables definen los parámetros configurables del monitoring

variable "environment" {
  # Nombre del ambiente (dev, uat, prod)
  # Usado para nombrar los recursos de forma única
  description = "Environment name"
  type        = string
}

variable "project_name" {
  # Nombre del proyecto para prefijo de recursos
  # Ejemplo: "devops-platform"
  description = "Project name for naming resources"
  type        = string
}

variable "alb_name" {
  # Nombre del ALB a monitorear
  # CloudWatch necesita esto para obtener métricas
  description = "ALB name for monitoring"
  type        = string
}

variable "asg_name" {
  # Nombre del Auto Scaling Group a monitorear
  description = "ASG name for monitoring"
  type        = string
}

variable "db_instance_id" {
  # ID de la instancia RDS a monitorear
  description = "RDS DB instance ID"
  type        = string
}

variable "alarm_email" {
  # Email donde enviar alertas (opcional)
  # Si no proporcionas, las alertas solo estarán en CloudWatch
  description = "Email for SNS notifications (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  # Tags adicionales para los recursos
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

# ============================================================================
# THRESHOLDS (UMBRALES DE ALERTA)
# ============================================================================
# Estos definen cuándo se activa una alarma

variable "cpu_threshold_high" {
  # Porcentaje de CPU que dispara alarma de ALTO
  # Si CPU > 80% durante 2 períodos → alarma
  description = "CPU threshold for high alarm (%)"
  type        = number
  default     = 80
}

variable "cpu_threshold_low" {
  # Porcentaje de CPU que dispara alarma de BAJO
  # Si CPU < 20% durante 2 períodos → alarma (para scale-down)
  description = "CPU threshold for low alarm (%)"
  type        = number
  default     = 20
}

variable "db_free_storage_threshold" {
  # Bytes de almacenamiento libre en RDS
  # Si storage libre < 5GB (5368709120 bytes) → alarma
  description = "RDS free storage threshold in bytes"
  type        = number
  default     = 5368709120  # 5 GB
}

variable "db_connection_threshold" {
  # Número máximo de conexiones a la base de datos
  # Si conexiones > 80 → alarma
  description = "RDS max connection threshold"
  type        = number
  default     = 80
}

variable "alb_unhealthy_threshold" {
  # Número de instancias no saludables en target group
  # Si >= 1 instancia no saludable → alarma
  description = "ALB unhealthy host threshold"
  type        = number
  default     = 1
}

variable "alb_response_time_threshold" {
  # Tiempo de respuesta máximo en segundos
  # Si respuesta > 1 segundo → alarma
  description = "ALB response time threshold in seconds"
  type        = number
  default     = 1
}
