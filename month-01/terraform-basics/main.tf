provider "aws" {
  region = "us-east-1"
  profile = "testasg"
}

variable "app_name" {
  type    = string
  default = "myapp"
}

resource "aws_s3_bucket" "app_storage" {
  bucket = "${var.app_name}-storage-prod"
}

# Create S3 bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-test-bucket-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name        = "Test bucket"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

output "storage_location" {
  value = aws_s3_bucket.app_storage.arn
}


# Output bucket information
output "bucket_name" {
  value       = aws_s3_bucket.test_bucket.id
  description = "Name of the S3 bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.test_bucket.arn
  description = "ARN of the S3 bucket"
}

output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS Account ID"
}
