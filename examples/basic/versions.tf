terraform {
  required_providers {
    archive = {
      version = "~> 2.0.0"
      source  = "hashicorp/archive"
    }
    aws = {
      version = ">= 3.0"
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 0.14"
}
