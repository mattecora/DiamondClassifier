# diamonds_lambda_predict_role_arn
# The ARN of the IAM execution role for the diamonds-endpoint-predict function.

variable "diamonds_lambda_predict_role_arn" {
    type = string
}

# diamonds_lambda_consume_role_arn
# The ARN of the IAM execution role for the diamonds-stream-consume function.

variable "diamonds_lambda_consume_role_arn" {
    type = string
}

# diamonds_data_stream_arn
# The ARN of the Kinesis data stream.

variable "diamonds_data_stream_arn" {
    type = string
}