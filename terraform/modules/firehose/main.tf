resource "aws_kinesis_firehose_delivery_stream" "diamonds_firehose_stream" {
    name        = "diamonds-firehose-stream"
    destination = "s3"

    kinesis_source_configuration {
        kinesis_stream_arn = var.diamonds_data_stream_arn
        role_arn           = var.diamonds_firehose_role_arn
    }

    s3_configuration {
        bucket_arn = var.diamonds_firehose_bucket_arn
        role_arn   = var.diamonds_firehose_role_arn
    }
}