terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "puneeth-remote-state1"
    key    = "expense-dev-frontend"
    region = "us-east-1"
    dynamodb_table = "puneeth-locking1"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}