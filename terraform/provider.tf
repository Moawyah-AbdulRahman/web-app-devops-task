terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "5.11.0"
    }
  }
    
    required_version = "v1.5.5"
}

provider "aws" {
  region = "eu-west-1"
}