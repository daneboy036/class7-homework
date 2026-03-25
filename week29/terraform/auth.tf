terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
  backend "s3" {
    bucket  = "bmc-daneboy-tf-state"
    key     = "class7/homework/week29.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Owner     = "dc"
    }
  }

  region = "us-east-1"
}
