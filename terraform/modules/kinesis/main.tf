resource "aws_kinesis_stream" "diamonds_data_stream" {
    name             = "diamonds-data-stream"
    shard_count      = 1
    retention_period = 24
}