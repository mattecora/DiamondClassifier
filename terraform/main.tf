terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws       = {
            source  = "hashicorp/aws"
            version = "~> 3.47"
        }
        archive   = {
            source  = "hashicorp/archive"
            version = "~> 2.2.0"
        }
        cloudinit = {
            source  = "hashicorp/cloudinit"
            version = "~> 2.2.0"
        }
    }

    backend "s3" {
        bucket  = "aws-project-politomaster-terraform-state"
        key     = "terraform.tfstate"
        region  = "eu-west-1"
        profile = "aws-project-master"
    }
}

# PROVIDERS CONFIGURATION

provider "aws" {
    profile = "aws-project-master"
    region  = "eu-west-1"
}

# MODULE IMPORTS

module "apigateway" {
    source = "./modules/apigateway"
    diamonds_lambda_predict_invoke_arn = module.lambda.diamonds_lambda_predict_invoke_arn
}

module "dynamodb" {
    source = "./modules/dynamodb"
}

module "ec2" {
    source = "./modules/ec2"
    diamonds_data_producer_profile_name = module.iam.diamonds_data_producer_profile_name
}

module "firehose" {
    source = "./modules/firehose"
    diamonds_data_stream_arn     = module.kinesis.diamonds_data_stream_arn
    diamonds_firehose_bucket_arn = module.s3.diamonds_firehose_bucket_arn
    diamonds_firehose_role_arn   = module.iam.diamonds_firehose_role_arn
}

module "iam" {
    source = "./modules/iam"
    diamonds_data_stream_arn        = module.kinesis.diamonds_data_stream_arn
    diamonds_firehose_bucket_arn    = module.s3.diamonds_firehose_bucket_arn
    diamonds_predictor_endpoint_arn = module.sagemaker.diamonds_predictor_endpoint_arn
    diamonds_predictions_table_arn  = module.dynamodb.diamonds_predictions_table_arn
    diamonds_batch_bucket_arn       = module.s3.diamonds_batch_bucket_arn
}

module "lambda" {
    source = "./modules/lambda"
    diamonds_lambda_predict_role_arn = module.iam.diamonds_lambda_predict_role_arn
    diamonds_lambda_batch_role_arn   = module.iam.diamonds_lambda_batch_role_arn
    diamonds_lambda_consume_role_arn = module.iam.diamonds_lambda_consume_role_arn
    diamonds_rest_api_execution_arn  = module.apigateway.diamonds_rest_api_execution_arn
    diamonds_batch_bucket_arn        = module.s3.diamonds_batch_bucket_arn
    diamonds_data_stream_arn         = module.kinesis.diamonds_data_stream_arn
}

module "kinesis" {
    source = "./modules/kinesis"
}

module "s3" {
    source = "./modules/s3"
    diamonds_rest_api_predict_base_url = module.apigateway.diamonds_rest_api_predict_base_url
    diamonds_lambda_batch_arn          = module.lambda.diamonds_lambda_batch_arn
}

module "sagemaker" {
    source = "./modules/sagemaker"
}

# GLOBAL OUTPUTS

output "diamonds_data_producer_ip_address" {
    value = module.ec2.diamonds_data_producer_ip_address
}

output "diamonds_frontend_bucket_endpoint" {
    value = module.s3.diamonds_frontend_bucket_endpoint
}

output "diamonds_rest_api_predict_base_url" {
    value = module.apigateway.diamonds_rest_api_predict_base_url
}