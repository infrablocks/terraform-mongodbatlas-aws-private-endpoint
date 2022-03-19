terraform {
  required_version = ">= 1.0"

  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "~> 1.3"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.29"
    }
  }
}