# diamonds_firehose_role
# The IAM execution role for the Firehose delivery stream.
# It allows reading from the Kinesis stream and writing to the S3 bucket.

resource "aws_iam_role" "diamonds_firehose_role" {
    name = "diamonds-firehose-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [   
            {
                Effect    = "Allow"
                Action    = "sts:AssumeRole"
                Principal = {
                    Service = "firehose.amazonaws.com"
                }
            }
        ]
    })

    inline_policy {
        name = "diamonds-firehose-policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards"
                    ],
                    Resource = var.diamonds_data_stream_arn
                },
                {      
                    Effect   = "Allow"     
                    Action   = [
                        "s3:AbortMultipartUpload",
                        "s3:GetBucketLocation",
                        "s3:GetObject",
                        "s3:ListBucket",
                        "s3:ListBucketMultipartUploads",
                        "s3:PutObject"
                    ],
                    Resource = [
                        var.diamonds_firehose_bucket_arn,
                        "${var.diamonds_firehose_bucket_arn}/*"
                    ]
                }
            ]
        })
    }
}

# diamonds_lambda_predict_role
# The IAM execution role for the diamonds-endpoint-predict Lambda function.
# It allows creating CloudWatch logs and invoking the Sagemaker endpoint.

resource "aws_iam_role" "diamonds_lambda_predict_role" {
    name = "diamonds-lambda-predict-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [   
            {
                Effect    = "Allow"
                Action    = "sts:AssumeRole"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    inline_policy {
        name = "diamonds-lambda-predict-policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ]
                    Resource = "*"
                },
                {      
                    Effect   = "Allow"     
                    Action   = "sagemaker:InvokeEndpoint"     
                    Resource = var.diamonds_predictor_endpoint_arn
                }
            ]
        })
    }
}

# diamonds_lambda_batch_role
# The IAM execution role for the diamonds-batch-predict Lambda function.
# It allows creating CloudWatch logs, reading/writing from/to S3 and invoking the Sagemaker endpoint.

resource "aws_iam_role" "diamonds_lambda_batch_role" {
    name = "diamonds-lambda-batch-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [   
            {
                Effect    = "Allow"
                Action    = "sts:AssumeRole"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    inline_policy {
        name = "diamonds-lambda-predict-policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ]
                    Resource = "*"
                },
                {
                    Effect   = "Allow"
                    Action   = [
                        "s3:GetObject",
                        "s3:PutObject"
                    ]
                    Resource = "${var.diamonds_batch_bucket_arn}/*"
                },
                {      
                    Effect   = "Allow"     
                    Action   = "sagemaker:InvokeEndpoint"     
                    Resource = var.diamonds_predictor_endpoint_arn
                }
            ]
        })
    }
}

# diamonds_lambda_consume_role
# The IAM execution role for the diamonds-stream-consume Lambda function.
# It allows creating CloudWatch logs, reading from the Kinesis stream, accessing the API gateway, and writing to the DynamoDB predictions table.

resource "aws_iam_role" "diamonds_lambda_consume_role" {
    name = "diamonds-lambda-consume-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [   
            {
                Effect    = "Allow"
                Action    = "sts:AssumeRole"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    inline_policy {
        name = "diamonds-lambda-consume-policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ]
                    Resource = "*"
                },
                {
                    Effect   = "Allow"
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:DescribeStreamSummary",
                        "kinesis:GetRecords",
                        "kinesis:GetShardIterator",
                        "kinesis:ListShards",
                        "kinesis:ListStreams",
                        "kinesis:SubscribeToShard"
                    ]
                    Resource = var.diamonds_data_stream_arn
                },
                {
                    Effect   = "Allow"
                    Action   = "apigateway:GET"
                    Resource = "arn:aws:apigateway:eu-west-1::/restapis"
                },
                {
                    Effect   = "Allow"
                    Action   = [
                        "dynamodb:BatchWriteItem",
                        "dynamodb:PutItem"
                    ]
                    Resource = var.diamonds_predictions_table_arn
                }
            ]
        })
    }
}

# diamonds_rest_api_predict_role
# The IAM execution role for the REST API.
# It allows invoking the diamonds-endpoint-predict Lambda function.

resource "aws_iam_role" "diamonds_rest_api_predict_role" {
    name = "diamonds-rest-api-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [   
            {
                Effect    = "Allow"
                Action    = "sts:AssumeRole"
                Principal = {
                    Service = "apigateway.amazonaws.com"
                }
            }
        ]
    })

    inline_policy {
        name = "diamonds-rest-api-predict-policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = "lambda:InvokeFunction"
                    Resource = var.diamonds_lambda_predict_arn
                }
            ]
        })
    }
}

# diamonds_data_producer_role
# The IAM execution role for the data producer instance.
# It allows reading test data from S3 and writing to the Kinesis stream.

resource "aws_iam_role" "diamonds_data_producer_role" {
    name = "diamonds-data-producer-role"

    assume_role_policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [   
            {
                Effect    = "Allow"
                Action    = "sts:AssumeRole"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    inline_policy {
        name = "diamonds-data-producer-policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {
                    Effect   = "Allow"
                    Action   = "s3:GetObject"
                    Resource = "arn:aws:s3:::aws-project-politomaster-sagemaker-data/*"
                },
                {
                    Effect   = "Allow"
                    Action   = [
                        "kinesis:PutRecord",
                        "kinesis:PutRecords"
                    ]
                    Resource = var.diamonds_data_stream_arn
                }
            ]
        })
    }
}

# diamonds_data_producer_profile
# The IAM profile for the data producer instance (roles cannot be directly attached to EC2).

resource "aws_iam_instance_profile" "diamonds_data_producer_profile" {
    name = "diamonds-data-producer-profile"
    role = aws_iam_role.diamonds_data_producer_role.name
}