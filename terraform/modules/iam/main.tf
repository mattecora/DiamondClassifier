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
                    Action   = "s3:*"     
                    Resource = var.diamonds_firehose_bucket_arn
                },        
                {
                    Effect   = "Allow"
                    Action   = "kinesis:*"
                    Resource = var.diamonds_data_stream_arn
                }
            ]
        })
    }
}