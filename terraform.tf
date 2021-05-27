terraform {
  required_version = ">= 0.14"

  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "~> 0.8"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.29"
    }
  }
}