terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.47"
        }
    }

    backend "s3" {
        bucket = "aws-project-politomaster-terraform-state"
        key    = "terraform.tfstate"
        region = "eu-west-1"
        profile = "aws-project-master"
    }
}

provider "aws" {
    profile = "aws-project-master"
    region  = "eu-west-1"
}

module "ec2" {
    source = "./modules/ec2"
}