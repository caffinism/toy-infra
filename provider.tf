terraform {

  backend "s3" {
    bucket         = "scott-tfstate-bucket"
    key            = "test/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "scott-terraform-lock"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.34"
    }
  }
  required_version = "~>1.3"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Billing = var.user_id
    }
  }
}