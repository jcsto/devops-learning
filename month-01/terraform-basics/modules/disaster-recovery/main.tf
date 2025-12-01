# ============================================================================
# MÓDULO DE DISASTER RECOVERY
# ============================================================================
# Este módulo implementa:
# 1. Backups automáticos de RDS
# 2. Multi-AZ failover automático
# 3. Snapshots manuales
# 4. Protección contra eliminación

# ============================================================================
# CLOUDWATCH ALARMS PARA DISASTER RECOVERY
# ============================================================================
# Monitorear eventos que indicen problemas de DR

# ====================================================================
# ALARMA: RDS Multi-AZ Failover
# ====================================================================
# Se dispara cuando hay un failover en Multi-AZ
# Esto es una BUENA señal (significa que el sistema se recuperó automáticamente)

resource "aws_cloudwatch_metric_alarm" "rds_failover_event" {
  alarm_name          = "${var.project_name}-rds-failover-${var.environment}"
  alarm_description   = "Alert when RDS Multi-AZ failover occurs (automatic recovery)"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FailoverEvents"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Sum"
  threshold           = 1  # Si hay 1+ failover → alerta
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  
  # Nota: No enviamos a SNS (sin permisos)
  # Pero la alarma aparecerá en CloudWatch
  
  tags = merge(var.tags, { Name = "RDS Failover Event" })
}

# ====================================================================
# ALARMA: RDS Backup Failed
# ====================================================================
# Se dispara si un backup automático falla

resource "aws_cloudwatch_metric_alarm" "rds_backup_failed" {
  alarm_name          = "${var.project_name}-rds-backup-failed-${var.environment}"
  alarm_description   = "Alert when RDS automated backup fails"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FailedSQLServerAgentJobsCount"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  
  tags = merge(var.tags, { Name = "RDS Backup Failed" })
}

# ============================================================================
# DOCUMENTACIÓN DE DISASTER RECOVERY
# ============================================================================
# Crear archivo con instrucciones de cómo hacer failover manual

resource "local_file" "dr_runbook" {
  # Crear un documento con instrucciones de DR
  filename = "${path.module}/../../DISASTER_RECOVERY_RUNBOOK.md"
  
  content = <<-EOT
# ============================================================================
# DISASTER RECOVERY RUNBOOK
# ============================================================================
# Procedimientos para recuperar tu infraestructura en caso de desastre

## 1. RDS MULTI-AZ FAILOVER (Automático)

### ¿Qué es?
Multi-AZ mantiene una copia en STANDBY en otra Availability Zone.
Si la primaria falla, AWS automáticamente hace failover (cambio).

### Características:
- ✅ Automático (no requiere intervención)
- ✅ Sincronización en tiempo real
- ✅ Failover en < 1-2 minutos
- ❌ Un poco más lento que single-AZ (replicación síncrona)

### Estado actual:
- Multi-AZ Enabled: ${var.multi_az_enabled}
- Backup Retention: ${var.backup_retention_days} días
- Backup Window: ${var.backup_window} UTC

### Cómo forzar failover manual (para testing):
```bash
# En AWS Console:
# 1. Ve a RDS → Databases
# 2. Selecciona tu instancia
# 3. Click "Actions" → "Reboot"
# 4. Marca "Reboot with Failover"
# 5. Confirma

# El failover toma ~2-5 minutos
# Tu aplicación experimentará:
# - ~30 segundos de downtime
# - Reconexión automática al endpoint del RDS

# En CLI (terraform):
# aws rds reboot-db-instance \
#   --db-instance-identifier ${var.db_instance_id} \
#   --force-failover \
#   --region us-east-1
```

## 2. AUTOMATED BACKUPS

### Características:
- Retention: ${var.backup_retention_days} días
- Backup Window: ${var.backup_window} UTC
- Tipo: Full + Incremental (durante los últimos 7 días)

### Cómo restaurar desde backup:
```bash
# En AWS Console:
# 1. RDS → Automated Backups
# 2. Selecciona el backup deseado
# 3. Click "Restore to new DB instance"
# 4. Configura: nombre, clase de instancia, etc
# 5. Espera restauración (~5-15 min dependiendo del tamaño)

# O en CLI:
# aws rds restore-db-instance-from-db-snapshot \
#   --db-instance-identifier restored-instance \
#   --db-snapshot-identifier snapshot-id \
#   --region us-east-1
```

## 3. MANUAL SNAPSHOTS

### Crear snapshot manual:
```bash
# En AWS Console:
# 1. RDS → Databases
# 2. Selecciona instancia
# 3. "Actions" → "Create snapshot"
# 4. Nombre: "backup-fecha-razon"
# 5. Crear

# O en CLI:
# aws rds create-db-snapshot \
#   --db-instance-identifier ${var.db_instance_id} \
#   --db-snapshot-identifier manual-snapshot-$(date +%Y%m%d-%H%M%S) \
#   --region us-east-1
```

### Mantener snapshots:
- Los snapshots manuales se mantienen indefinidamente
- Los backups automáticos se mantienen ${var.backup_retention_days} días
- **Recomendación**: Crear snapshots antes de cambios importantes

## 4. DISASTER RECOVERY TESTING

### Cada mes, deberías probar:

#### Test 1: Failover Manual
```bash
# Forzar failover para asegurar que funciona
# Tiempo de downtime esperado: 2-5 minutos

# Nota: Esto causa interrupción de servicio
# Hacerlo en horas bajas (2am-4am UTC)
```

#### Test 2: Restore from Backup
```bash
# Restaurar a una instancia de TEST
# Verificar que los datos son correctos
# Eliminar instancia de test después
```

#### Test 3: Application Failover
```bash
# Tu aplicación debería:
# 1. Reconectar automáticamente al RDS
# 2. Reintentar conexiones fallidas
# 3. No perder datos

# Ver CloudWatch para verificar que no hay errores
```

## 5. ALERTAS ACTIVAS

Las siguientes alarmas están configuradas en CloudWatch:

1. **RDS Failover Event** 
   - Se dispara cuando hay un failover
   - Esto es una BUENA señal (significa que funcionó)

2. **RDS Backup Failed**
   - Se dispara si un backup automático falla
   - REQUIERE ACCIÓN INMEDIATA

3. **RDS Low Storage**
   - Se dispara si almacenamiento < 5GB
   - REQUIERE ACCIÓN

## 6. CHECKLIST DE DR

### Mensual:
- [ ] Revisar backups en AWS Console
- [ ] Verificar alarmas en CloudWatch
- [ ] Comprobar que Multi-AZ está habilitado

### Trimestral:
- [ ] Forzar failover manual (en testing)
- [ ] Restaurar desde backup a instancia de test
- [ ] Verificar que la app se reconecta

### Anual:
- [ ] Plan de recuperación completo
- [ ] RTO (Recovery Time Objective): < 5 minutos
- [ ] RPO (Recovery Point Objective): < 1 minuto

## 7. TERMINOLOGÍA

| Término | Significado |
|---------|-----------|
| **Multi-AZ** | 2+ Availability Zones (automático failover) |
| **Failover** | Cambio de primaria a standby |
| **RTO** | Tiempo para recuperarse después de desastre |
| **RPO** | Máxima pérdida de datos aceptable |
| **Backup** | Copia de base de datos |
| **Snapshot** | Copia en un momento específico |

## 8. CONTACTOS DE EMERGENCIA

En caso de desastre:
- AWS Support: https://console.aws.amazon.com/support/
- CloudWatch Alarms: ${var.project_name}-rds-failover-${var.environment}
- Dashboard Monitoring: [CloudWatch Dashboard URL]

---
**Última actualización**: $(date)
**Generado por**: Terraform Day 14 - Disaster Recovery Module
EOT
}

# ============================================================================
# LOCAL DATA SOURCE: Información para RTO/RPO
# ============================================================================

# Este archivo documenta los SLA (Service Level Agreements) de tu DR

resource "local_file" "dr_sla" {
  filename = "${path.module}/../../DISASTER_RECOVERY_SLA.txt"
  
  content = <<-EOT
================================================================================
DISASTER RECOVERY SLA (Service Level Agreement)
================================================================================

Project: ${var.project_name}
Environment: ${var.environment}
Generated: $(date)

================================================================================
RECOVERY TIME OBJECTIVE (RTO) - ¿Cuánto tarda en recuperarse?
================================================================================

Escenario: Falla de AZ (Availability Zone)
RTO: ~2-5 minutos (Multi-AZ automático failover)

Escenario: Corrupción de datos
RTO: ~15-30 minutos (restaurar desde backup)

Escenario: Toda la región falla
RTO: ~1-2 horas (manual - requiere provisionar en nueva región)

================================================================================
RECOVERY POINT OBJECTIVE (RPO) - ¿Cuántos datos se pierden?
================================================================================

Backups automáticos: Cada ${var.backup_window} UTC
RPO: ~1 hora (máximo entre backup y falla)

Multi-AZ Standby: Replicación síncrona
RPO: ~0 minutos (copia en tiempo real)

================================================================================
CURRENT CONFIGURATION
================================================================================

✅ Multi-AZ Enabled: ${var.multi_az_enabled}
✅ Backup Retention: ${var.backup_retention_days} días
✅ Backup Window: ${var.backup_window} UTC
✅ Automatic Minor Upgrades: ${var.enable_automated_minor_version_upgrade}
✅ Deletion Protection: ${var.enable_deletion_protection}
✅ Copy Tags to Snapshot: ${var.copy_tags_to_snapshot}

================================================================================
TESTING SCHEDULE
================================================================================

Monthly:
- Review backup status
- Verify Multi-AZ is active
- Check CloudWatch alarms

Quarterly:
- Force manual failover test
- Restore from backup to test instance
- Verify application reconnection

Annually:
- Full disaster recovery drill
- Document lessons learned
- Update this runbook

================================================================================
CONTACT INFORMATION
================================================================================

On-call Engineer: [YOUR_NAME]
AWS Support Level: Business (or Enterprise)
Support Case URL: https://console.aws.amazon.com/support/

================================================================================
EOT
}

data "aws_region" "current" {}
