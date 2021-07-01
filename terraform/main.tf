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

module "iam" {
    source = "./modules/iam"
}

module "s3" {
    source = "./modules/s3"
}

module "ec2" {
    source = "./modules/ec2"
}

module "kinesis" {
    source = "./modules/kinesis"
    firehose_role_arn = module.iam.firehose_role_arn
    firehose_bucket_arn = module.s3.firehose_bucket_arn
}