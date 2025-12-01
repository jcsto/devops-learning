# ============================================================================
# VARIABLES PARA MÓDULO DE DISASTER RECOVERY
# ============================================================================
# Este módulo configura backups, snapshots y failover automático

variable "environment" {
  # dev, uat, prod
  description = "Environment name"
  type        = string
}

variable "project_name" {
  # Nombre del proyecto
  description = "Project name"
  type        = string
}

variable "db_instance_id" {
  # ID de la instancia RDS a proteger
  description = "RDS DB instance ID"
  type        = string
}

variable "backup_retention_days" {
  # Cuántos días mantener backups automáticos
  # 7 días = 1 semana de historial
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "backup_window" {
  # Ventana de tiempo para backups automáticos (UTC)
  # 03:00-04:00 UTC = 10 PM - 11 PM EST (hora de NY)
  description = "Daily backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "multi_az_enabled" {
  # ¿Habilitar Multi-AZ en RDS?
  # true = standby en otra AZ (automático failover)
  description = "Enable Multi-AZ for RDS"
  type        = bool
  default     = true
}

variable "enable_automated_minor_version_upgrade" {
  # ¿Actualizar versiones menores automáticamente?
  # true = aplicar parches automáticamente
  description = "Enable automated minor version upgrades"
  type        = bool
  default     = true
}

variable "preferred_maintenance_window" {
  # Ventana de mantenimiento (cuando se aplican updates)
  # Format: ddd:hh:mm-ddd:hh:mm (UTC)
  # mon:04:00-mon:05:00 = lunes 4am-5am UTC
  description = "Preferred maintenance window"
  type        = string
  default     = "mon:04:00-mon:05:00"
}

variable "copy_tags_to_snapshot" {
  # ¿Copiar tags a los snapshots automáticos?
  # true = los snapshots heredan los tags de la instancia
  description = "Copy tags to snapshots"
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  # ¿Proteger contra eliminación accidental?
  # true = no se puede eliminar sin desactivar primero
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
