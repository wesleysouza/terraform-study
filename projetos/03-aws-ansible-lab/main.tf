terraform {
  backend "s3" {
    bucket = "lab-terraform-wesley"
    key    = "terraform-test.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "us-east-2"
  version = "~> 3.0"
}