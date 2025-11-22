#!/bin/bash

# 🚀 GITHUB REPO SETUP SCRIPT
# Crea la estructura completa del devops-learning repo

set -e

REPO_NAME="devops-learning"
REPO_DIR="$HOME/$REPO_NAME"

echo "📁 Creating repository structure..."

# Create base directory
mkdir -p "$REPO_DIR"
cd "$REPO_DIR"

# Initialize git
git init
git config user.email "julio.cesar.mesa.glez@gmail.com"
git config user.name "Julio Cesar"

# Create .gitignore
cat > .gitignore << 'EOF'
# Terraform
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
crash.log
*.tfvars
!*.tfvars.example

# AWS
.aws/
*.pem
*.ppk
credentials

# Docker
.docker/
*.log

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Python
__pycache__/
*.py[cod]
*$py.class
.env
venv/

# Node
node_modules/
npm-debug.log
EOF

# Create directory structure for months
for month in {01..18}; do
	month_name=$(printf "month-%d" $((#month)))
    mkdir -p "$month_name"
    
    # Create placeholder README
    cat > "$month_name/README.md" << EOF
# Month $month - [Topic Name]

## 🎯 Objetivo
[Describe el objetivo de este mes]

## 📚 Contenido
- [ ] Concepto 1
- [ ] Concepto 2
- [ ] Concepto 3

## 🚀 Proyectos
1. Proyecto 1.1
2. Proyecto 1.2

## 📊 Resultados
[Agrega resultados aquí]

## ✅ Status: TODO
EOF
done

# Create main README
cat > README.md << 'EOF'
# 🚀 DevOps Learning Journey

18-month learning plan to reach **Staff/Senior DevOps Engineer** level with specialization in **AI Infrastructure** for **healthcare applications**.

## 📊 Plan Overview

| Month | Topic | Status | Projects |
|-------|-------|--------|----------|
| 1 | System Design + Terraform Basics | ⏳ TODO | 3 |
| 2 | AWS Compute | ⏳ TODO | 2 |
| 3 | AWS Storage & Networking | ⏳ TODO | 2 |
| 4 | Databases + Postgres Deep Dive | ⏳ TODO | 3 |
| 5 | Monitoring + Disaster Recovery | ⏳ TODO | 3 |
| 6 | Security + Cloud Migration | ⏳ TODO | 3 |
| 7 | Terraform Advanced | ⏳ TODO | 2 |
| 8 | CI/CD + DevOps | ⏳ TODO | 2 |
| 9 | Docker & Containerization | ⏳ TODO | 2 |
| 10 | Kubernetes + Observability + Datadog | ⏳ TODO | 3 |
| 11 | Kubernetes Intermediate | ⏳ TODO | 2 |
| 12 | Kubernetes Advanced + GitOps | ⏳ TODO | 2 |
| 13 | AI/MLOps Foundations | ⏳ TODO | 2 |
| 14 | AI/MLOps Infrastructure | ⏳ TODO | 2 |
| 15 | Feature Stores + Platform Engineering | ⏳ TODO | 2 |
| 16 | End-to-End Project + AWS Certs | ⏳ TODO | 1 |
| 17 | Technical Communication | ⏳ TODO | 1 |
| 18 | Interview Prep + Job Search | ⏳ TODO | 1 |

**Total Projects:** 40+  
**Total Hours:** 1,228-1,236  
**Time Commitment:** ~1h/day  
**Target Role:** Staff/Senior DevOps Engineer ($200-250k)  

## 📚 Key Areas

- **Infrastructure as Code:** Terraform, CloudFormation
- **Cloud Platforms:** AWS (deep), multi-cloud awareness
- **Containerization:** Docker, Kubernetes (EKS)
- **Observability:** Prometheus, Grafana, Datadog, Loki
- **CI/CD:** GitHub Actions, GitLab CI, Git Hooks
- **Platform Engineering:** DX, Golden Paths, Backstage
- **AI/MLOps:** Feature Stores, Model Serving, ML Monitoring
- **Healthcare:** HIPAA compliance, data privacy
- **Technical Communication:** RFC, ADR, architecture docs

## 🎯 Projects by Category

### System Design & Architecture
- Month 1: System Design Handbook

### Infrastructure as Code
- Month 1: First Terraform Project
- Month 4: RDS + PostgreSQL
- Month 5: Cross-Region DR Setup
- Month 6: Cloud Migration Infrastructure

### AWS
- Months 1-6: Comprehensive AWS setup

### Containerization
- Month 9: Docker fundamentals

### Kubernetes
- Months 10-12: Kubernetes journey

### Observability
- Month 10: Prometheus + Grafana + Datadog

### AI/MLOps
- Months 13-15: AI Infrastructure

### Capstone
- Months 16-18: End-to-End project

## 📝 How to use this repo

1. **Follow the month folders** - each month has projects and documentation
2. **Complete projects** - build, test, document
3. **Push to GitHub** - use meaningful commit messages
4. **Track progress** - update this README monthly
5. **Build portfolio** - showcase projects for interviews

## 🔗 Quick Links

- [Learning Plan](../PLAN_FINAL_18MESES_V4_ACTUALIZADO.docx)
- [Project Strategy](../PROYECTOS_PRACTICOS_GITHUB_STRATEGY.md)
- [GitHub Actions Workflows](.github/workflows/)

## 📈 Progress Tracking

**Current Status:** Starting Month 1  
**Months Completed:** 0/18  
**Projects Completed:** 0/40+  
**GitHub Commits:** 0  

## 🚀 Latest Projects

| Project | Month | Status | Link |
|---------|-------|--------|------|
| - | - | - | - |

## 👤 About

Learning DevOps engineering with focus on infrastructure automation, cloud architecture, and AI/MLOps infrastructure for healthcare applications.

Target: **Staff/Senior DevOps Engineer** | **AI Infrastructure Specialist**

---

**Last Updated:** [DATE]  
**Next Checkpoint:** End of Month 1  

