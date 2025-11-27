# Terraform CI/CD Pipeline - Day 12

## Overview

Este pipeline automatiza deployments de Terraform usando GitHub Actions. Cada push y PR dispara validación automática.

## Workflows

### 1. `terraform.yml` - Main CI/CD Pipeline

**Triggadores:**
- `push` a main/develop (en cambios de terraform-basics)
- `pull_request` a main

**Jobs:**
1. **terraform-plan** (siempre corre)
   - Checkout código
   - Setup Terraform
   - Configure AWS credentials
   - Valida formato (`terraform fmt`)
   - Inicializa Terraform
   - Valida sintaxis
   - Genera plan
   - Comenta el plan en PRs
   - Sube plan como artifact

2. **terraform-apply** (solo en push a main)
   - Require: terraform-plan completado
   - Ejecuta `terraform apply -auto-approve`
   - Sube outputs
   - Notifica éxito/fallo

### 2. `terraform-security.yml` - Security Scanning

**Herramientas:**
- **tfsec**: Detecta security issues en Terraform
- **Checkov**: Valida compliance y mejores prácticas

**Reportes:**
- SARIF format para GitHub Security tab
- Soft fail: No bloquea pero alerta

## Setup Requerido

### 1. AWS Credentials en GitHub Secrets

En GitHub repo settings → Secrets and variables → Actions:

```
AWS_ACCESS_KEY_ID: <tu-access-key>
AWS_SECRET_ACCESS_KEY: <tu-secret-key>
```

**IMPORTANTE**: Usar credenciales con permisos limitados (IAM user específico para CI/CD)

### 2. Branch Protection Rules (opcional pero recomendado)

En GitHub repo settings → Branches → Branch protection rules:

```
- Require status checks to pass before merging
  - terraform-plan must pass
  - tfsec must pass
```

## Flujo de Trabajo

### Crear Feature Branch y Hacer Cambios

```bash
git checkout -b feature/add-lambda-module
cd terraform-basics/modules
mkdir lambda
# ... agregar módulo ...
```

### Commit y Push

```bash
git add -A
git commit -m "feat: add lambda module"
git push origin feature/add-lambda-module
```

### GitHub Actions Automáticamente

1. **Detecta cambios** en terraform-basics/
2. **Corre terraform-plan**:
   - Valida formato
   - Valida sintaxis
   - Genera plan
   - Comenta plan en PR
3. **Corre security scans**:
   - tfsec detecta issues
   - Checkov valida compliance
4. **Espera aprobación** del reviewer
5. **Merge a main** (si todo pasó)

### Merge a Main Automáticamente Aplica

```
Push a main → terraform-plan → terraform-apply
```

El apply es automático en main. En otras ramas solo hace plan.

## Ejemplo: PR Comment

Cuando creas un PR, GitHub Actions comenta automáticamente:

```
## Terraform Plan

Terraform will perform the following actions:

+ module.lambda.aws_lambda_function.main
    id: (known after apply)
    ...

Plan: 2 to add, 0 to change, 0 to destroy.

**Plan Status**: success
```

## Variables de Ambiente

En `terraform.yml`:

```yaml
env:
  AWS_REGION: us-east-1      # Cambiar si necesario
  TF_VERSION: 1.6.0          # Actualizar si necesario
```

## Troubleshooting

### ❌ AWS Credentials Error

```
Error: AWS was not able to validate the provided access credentials
```

**Solución:**
1. Verifica que AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY están en GitHub Secrets
2. Verifica que las credenciales son válidas
3. Verifica que el IAM user tiene permisos necesarios

### ❌ Terraform Init Fails

```
Error: Module not found
```

**Solución:**
1. Asegúrate que todos los módulos están commiteados
2. Verifica que la ruta en source es correcta

### ❌ Plan Shows Changes pero Apply Falla

```
Error: creating resource
```

**Solución:**
1. Checa los logs de GitHub Actions
2. Verifica permisos IAM del user de CI/CD
3. Revisa terraform.tfvars para valores sensibles

## Mejoras Futuras (Day 13+)

- [ ] Notificaciones por Slack
- [ ] Terraform cost estimation (infracost)
- [ ] Policy as Code (Sentinel)
- [ ] Multi-environment approval gates
- [ ] Automated testing (terratest)
- [ ] Drift detection

## Referencias

- [GitHub Actions Terraform Docs](https://github.com/hashicorp/setup-terraform)
- [AWS Credentials Setup](https://github.com/aws-actions/configure-aws-credentials)
- [TFSec](https://aquasecurity.github.io/tfsec/)
- [Checkov](https://www.checkov.io/)
