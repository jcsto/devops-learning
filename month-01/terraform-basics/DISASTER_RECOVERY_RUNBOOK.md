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
- Multi-AZ Enabled: true
- Backup Retention: 7 días
- Backup Window: 03:00-04:00 UTC

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
#   --db-instance-identifier devops-platform-db-20251126040314138900000001 \
#   --force-failover \
#   --region us-east-1
```

## 2. AUTOMATED BACKUPS

### Características:
- Retention: 7 días
- Backup Window: 03:00-04:00 UTC
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
#   --db-instance-identifier devops-platform-db-20251126040314138900000001 \
#   --db-snapshot-identifier manual-snapshot-$(date +%Y%m%d-%H%M%S) \
#   --region us-east-1
```

### Mantener snapshots:
- Los snapshots manuales se mantienen indefinidamente
- Los backups automáticos se mantienen 7 días
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
- CloudWatch Alarms: devops-platform-rds-failover-dev
- Dashboard Monitoring: [CloudWatch Dashboard URL]

---
**Última actualización**: $(date)
**Generado por**: Terraform Day 14 - Disaster Recovery Module
