terraform {
  required_version = "~> 1.6.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1"
    }
  }

  backend "s3" {
    bucket         = "api-gateway-tf-state"
    key            = "api-gateway/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "api-gateway-tf-state-lock"
  }

}

provider "aws" {
  region = "us-east-1"
}
