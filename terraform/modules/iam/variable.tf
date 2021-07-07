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

# diamonds_predictor_endpoint_arn
# The ARN of the deployed Sagemaker endpoint.

variable "diamonds_predictor_endpoint_arn" {
    type = string
}

# diamonds_predictions_table_arn
# The ARN of the DynamoDB predictions table.

variable "diamonds_predictions_table_arn" {
    type = string
}

# diamonds_batch_bucket_arn
# The ARN of the batch prediction bucket.

variable "diamonds_batch_bucket_arn" {
    type = string
}