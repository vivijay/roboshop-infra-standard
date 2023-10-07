terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
    }
  }
  backend "s3" {
    bucket = "roboshop-remote-state-default"
    key = "cart"
    region = "us-east-1"
    dynamodb_table = "roboshop-default"
    
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}