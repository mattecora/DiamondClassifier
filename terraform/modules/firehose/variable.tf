# diamonds_data_stream_arn
# The ARN of the Kinesis data stream.

variable "diamonds_data_stream_arn" {
    type = string
}

# diamonds_firehose_bucket_arn
# The ARN of the Firehose bucket.

variable "diamonds_firehose_bucket_arn" {
    type = string
}

# diamonds_firehose_role_arn
# The ARN of the IAM execution role for the Firehose delivery stream.

variable "diamonds_firehose_role_arn" {
    type = string
}