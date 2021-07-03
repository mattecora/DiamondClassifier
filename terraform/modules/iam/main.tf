resource "aws_iam_role" "diamonds_firehose_role" {
    name = "firehose-role"

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
        name = "diamonds_firehose_role_policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
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
                    Resource = var.diamonds_firehose_bucket_arn
                },
                {
                    Effect   = "Allow"
                    Action   = [
                        "kinesis:DescribeStream",
                        "kinesis:GetShardIterator",
                        "kinesis:GetRecords",
                        "kinesis:ListShards"
                    ],
                    Resource = var.diamonds_data_stream_arn
                }
            ]
        })
    }
}

resource "aws_iam_role" "diamonds_lambda_predict_role" {
    name = "lambda-predict-role"

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
        name = "diamonds_lambda_predict_role_policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [
                {      
                    Effect   = "Allow"     
                    Action   = "sagemaker:InvokeEndpoint"     
                    Resource = var.diamonds_sagemaker_endpoint_arn
                }
            ]
        })
    }
}

resource "aws_iam_role" "diamonds_lambda_consume_role" {
    name = "lambda-consume-role"

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
        name = "diamonds_lambda_consume_policy"
        policy = jsonencode({
            Version   = "2012-10-17"
            Statement = [      
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
                    Action   = [
                        "dynamodb:BatchWriteItem",
                        "dynamodb:PutItem"
                    ]
                    Resource = var.diamonds_data_stream_arn
                }
            ]
        })
    }
}