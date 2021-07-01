terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.47"
        }
    }

    backend "s3" {
        bucket  = "aws-project-politomaster-terraform-state"
        key     = "terraform.tfstate"
        region  = "eu-west-1"
        profile = "aws-project-master"
    }
}

provider "aws" {
    profile = "aws-project-master"
    region  = "eu-west-1"
}

module "dynamodb" {
    source = "./modules/dynamodb"
}

module "ec2" {
    source = "./modules/ec2"
}

module "firehose" {
    source = "./modules/firehose"
    diamonds_data_stream_arn     = module.kinesis.diamonds_data_stream_arn
    diamonds_firehose_bucket_arn = module.s3.diamonds_firehose_bucket_arn
    diamonds_firehose_role_arn   = module.iam.diamonds_firehose_role_arn
}

module "iam" {
    source = "./modules/iam"
    diamonds_data_stream_arn     = module.kinesis.diamonds_data_stream_arn
    diamonds_firehose_bucket_arn = module.s3.diamonds_firehose_bucket_arn
}

module "kinesis" {
    source = "./modules/kinesis"
}

module "s3" {
    source = "./modules/s3"
}