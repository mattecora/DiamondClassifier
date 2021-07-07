# diamonds_data_stream_arn
# The ARN of the Kinesis data stream.

output "diamonds_data_stream_arn" {
    value = aws_kinesis_stream.diamonds_data_stream.arn
}