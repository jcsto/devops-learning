# Month 1 - System Design Fundamentals + Terraform Basics

## 📋 Projects Structure

```
month-01/
├── README.md (this file)
├── system-design-handbook/
│   ├── README.md
│   ├── architecture-diagrams/
│   │   ├── 01-simple-web-app.md
│   │   ├── 02-scalable-system.md
│   │   ├── 03-high-availability.md
│   │   └── 04-distributed-system.md
│   └── excalidraw-exports/
│       ├── simple-web-app.json
│       ├── scalable-system.json
│       └── ...
├── terraform-basics/
│   ├── README.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
└── aws-fundamentals-lab/
    ├── README.md
    ├── main.tf
    ├── architecture.md
    └── test-results/
```

---

## 📖 PROJECT 1.1: System Design Handbook

### 🎯 Objetivo
Crear 4 arquitecturas documentadas que demuestren:
- Escalabilidad horizontal y vertical
- Alta disponibilidad (99.9% uptime)
- Resiliencia ante fallos
- Trade-offs de diseño

### 📚 Arquitecturas a documentar

#### 1. Simple Web Application
**Componentes:**
- Client
- Web Server (Single)
- Database (Single)

**Características:**
- Usuarios: 1K concurrent
- Traffic: 100 req/sec
- Availability: 95%

**Limitaciones:**
- Single point of failure
- No horizontal scaling
- Database bottleneck

**Diagram (ASCII):**
```
[Clients] 
    |
    v
[Web Server]
    |
    v
[Database]
```

**Learnings:**
- [ ] Single server limitations
- [ ] Database as bottleneck
- [ ] Single point of failure risks

---

#### 2. Scalable Web Application
**Componentes:**
- Clients
- Load Balancer
- Multiple Web Servers (3-5)
- Cache Layer (Redis)
- Database (Primary + Replica)

**Características:**
- Usuarios: 100K concurrent
- Traffic: 10K req/sec
- Availability: 99.5%
- Response time: <200ms

**Improvements:**
- Horizontal scaling (servers)
- Caching layer (reduce DB load)
- Database replication (read scaling)
- Load balancing (traffic distribution)

**Diagram (ASCII):**
```
[Clients (100K)]
        |
        v
[Load Balancer]
    /   |   \
   /    |    \
  v     v     v
[Web] [Web] [Web]
  \     |     /
   \    |    /
    \   |   /
        v
    [Cache - Redis]
        |
    [DB Primary]
     /      \
    /        \
   v          v
[Read Rep] [Read Rep]
```

**Trade-offs:**
- Complexity increases
- More servers = more maintenance
- Cache invalidation challenges
- Network latency

**Learnings:**
- [ ] Load balancing algorithms
- [ ] Caching strategies (write-through, cache-aside)
- [ ] Database replication
- [ ] Horizontal scaling limits

---

#### 3. High Availability System
**Componentes:**
- Multi-region setup
- Load Balancers (per region)
- Web Servers (per region)
- Cache (distributed)
- Database (Multi-AZ, cross-region replica)
- CDN
- Message Queue

**Características:**
- Usuarios: 1M concurrent
- Traffic: 100K req/sec
- Availability: 99.99%
- Disaster recovery capability

**Features:**
- Geographic redundancy
- Automatic failover (AZ level)
- Content delivery via CDN
- Async processing (queue)
- Cache consistency

**Diagram:**
```
[Global Traffic] → [Route 53 / Global LB]
                      /          \
                 Region 1      Region 2
                    |              |
        [Regional LB]          [Regional LB]
         /    |    \            /    |    \
      [W] [W] [W]            [W] [W] [W]
         \    |    /            \    |    /
            [Cache]                [Cache]
                |                      |
              [CDN] ←────────────→ [CDN]
                    Sync content

        [Primary DB (Region 1)]
                    |
        [Cross-region Replica]
                    |
              [Message Queue]
```

**Trade-offs:**
- Significant complexity
- High operational overhead
- Cost (multiple regions)
- Eventual consistency challenges

**Learnings:**
- [ ] Multi-region architecture
- [ ] Geographic failover
- [ ] CDN benefits/limitations
- [ ] Distributed cache consistency

---

#### 4. Distributed System (Microservices)
**Componentes:**
- API Gateway
- Microservices (User, Product, Order, Payment)
- Service Mesh (Istio)
- Kubernetes cluster
- Distributed tracing
- Event streaming (Kafka)
- Multiple databases (polyglot)

**Características:**
- Usuarios: 10M+ concurrent
- Traffic: 1M+ req/sec
- Availability: 99.999%
- Complex workflows

**Features:**
- Service isolation
- Independent scaling per service
- Circuit breaker pattern
- Distributed tracing
- Event-driven workflows
- Polyglot persistence

**Diagram:**
```
[Clients (10M+)]
        |
   [API Gateway]
        |
    [Service Mesh - Istio]
    / | | | | \
   /  |  |  |  \
[User][Product][Order][Payment]...
  |     |        |       |
[DB] [DB]      [DB]    [DB]
       |
    [Kafka] → Event streaming
       |
[Distributed Tracing - Jaeger]
```

**Trade-offs:**
- Very complex
- Debugging difficult (distributed tracing needed)
- Network latency
- Data consistency challenges
- Operational complexity

**Learnings:**
- [ ] Microservices architecture
- [ ] Service mesh (Istio/Linkerd)
- [ ] Event-driven architecture
- [ ] Polyglot persistence
- [ ] Distributed tracing
- [ ] Circuit breaker pattern

---

### 📊 Comparison Matrix

| Aspect | Simple | Scalable | HA | Distributed |
|--------|--------|----------|----|----|
| Concurrent Users | 1K | 100K | 1M | 10M+ |
| Requests/sec | 100 | 10K | 100K | 1M+ |
| Availability | 95% | 99.5% | 99.99% | 99.999% |
| Complexity | Low | Medium | High | Very High |
| Cost | $100-300/mo | $1-5K/mo | $10-50K/mo | $50-200K+/mo |
| Team size | 1-2 | 5-10 | 10-20 | 20-50+ |
| Deployment time | Minutes | Hours | Hours | Days |

---

## 🔧 PROJECT 1.2: First Terraform Project

### 📁 Files

**main.tf**
```hcl
# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# S3 Bucket
resource "aws_s3_bucket" "learning_bucket" {
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    CreatedBy   = "Terraform"
    Month       = "Month-01"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "learning_bucket" {
  bucket = aws_s3_bucket.learning_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "learning_bucket" {
  bucket = aws_s3_bucket.learning_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# RDS Subnet Group
resource "aws_db_subnet_group" "learning_rds" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# RDS Database
resource "aws_db_instance" "learning_db" {
  identifier            = "${var.environment}-learning-db"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = var.db_instance_class
  allocated_storage     = 20
  storage_type          = "gp2"
  db_name               = "learningdb"
  username              = var.db_username
  password              = var.db_password
  db_subnet_group_name  = aws_db_subnet_group.learning_rds.name
  skip_final_snapshot   = true

  tags = {
    Name = "${var.environment}-learning-db"
  }
}

# Data source: AWS account ID
data "aws_caller_identity" "current" {}
```

**variables.tf**
```hcl
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
  default     = "my-learning-bucket"
}

variable "db_instance_class" {
  type        = string
  description = "Database instance class"
  default     = "db.t3.micro"
}

variable "db_username" {
  type        = string
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for RDS"
}
```

**outputs.tf**
```hcl
output "s3_bucket_name" {
  value       = aws_s3_bucket.learning_bucket.id
  description = "S3 bucket name"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.learning_bucket.arn
  description = "S3 bucket ARN"
}

output "rds_endpoint" {
  value       = aws_db_instance.learning_db.endpoint
  description = "RDS database endpoint"
}

output "rds_database_name" {
  value       = aws_db_instance.learning_db.db_name
  description = "Database name"
}
```

**terraform.tfvars.example**
```hcl
aws_region    = "us-east-1"
environment   = "dev"
bucket_name   = "my-learning-bucket"
db_username   = "admin"
db_password   = "CHANGE_ME"
subnet_ids    = ["subnet-xxxxx", "subnet-yyyyy"]
```

### ✅ Workflow

```bash
# 1. Initialize
terraform init

# 2. Plan
terraform plan -out=tfplan

# 3. Apply
terraform apply tfplan

# 4. Verify (AWS Console or CLI)
aws s3 ls
aws rds describe-db-instances

# 5. Destroy (cleanup)
terraform destroy
```

---

## 🚀 PROJECT 1.3: AWS Fundamentals Lab

### Architecture
- EC2 instance + security group
- Application Load Balancer
- RDS database
- Auto Scaling Group (theory)

### Deliverables
- [ ] Terraform code (EC2 + ALB + RDS)
- [ ] Architecture diagram
- [ ] Test results (connectivity, performance)
- [ ] Documentation

---

## ✅ Checklist: Month 1 Complete

- [ ] System Design Handbook (4 architectures documented)
- [ ] Terraform basics project (S3 + RDS working)
- [ ] AWS Fundamentals lab (all resources created + verified)
- [ ] All code pushed to GitHub
- [ ] README files complete for each project
- [ ] No secrets committed (.gitignore working)
- [ ] Terraform files formatted + validated

---

**Total Time:** ~60 hours  
**Status:** 🟢 Ready to start  
**Next:** Month 2 - AWS Compute

