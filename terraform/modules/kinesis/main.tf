resource "aws_kinesis_stream" "diamonds_data_stream" {
    name             = "diamonds-data-stream"
    shard_count      = 1
    retention_period = 24
}

resource "aws_kinesis_firehose_delivery_stream" "diamonds_firehose_stream" {
    name        = "diamonds-firehose-stream"
    destination = "s3"

    s3_configuration {
        role_arn   = var.diamonds_firehose_role_arn
        bucket_arn = var.diamonds_firehose_bucket_arn
    }
}