terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
  backend "s3" {
    bucket = "puneeth-remote-state1"
    key    = "expense-dev-db"
    region = "us-east-1"
    dynamodb_table = "puneeth-locking1"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}