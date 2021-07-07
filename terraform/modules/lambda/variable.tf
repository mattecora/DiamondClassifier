# diamonds_lambda_predict_role_arn
# The ARN of the IAM execution role for the diamonds-endpoint-predict function.

variable "diamonds_lambda_predict_role_arn" {
    type = string
}

# diamonds_lambda_batch_role_arn
# The ARN of the IAM execution role for the diamonds-batch-predict function.

variable "diamonds_lambda_batch_role_arn" {
    type = string
}

# diamonds_lambda_consume_role_arn
# The ARN of the IAM execution role for the diamonds-stream-consume function.

variable "diamonds_lambda_consume_role_arn" {
    type = string
}

# diamonds_rest_api_execution_arn
# The ARN of the deployed REST API.

variable "diamonds_rest_api_execution_arn" {
    type = string
}

# diamonds_batch_bucket_arn
# The ARN of the batch prediction bucket.

variable "diamonds_batch_bucket_arn" {
    type = string
}

# diamonds_data_stream_arn
# The ARN of the Kinesis data stream.

variable "diamonds_data_stream_arn" {
    type = string
}