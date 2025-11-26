# Backend local para desarrollo
# Cambiar a S3 backend en producción
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

