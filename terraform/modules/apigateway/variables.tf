# diamonds_lambda_predict_invoke_arn
# The invoke ARN of the diamonds-endpoint-predict function.

variable "diamonds_lambda_predict_invoke_arn" {
    type = string
}

# diamonds_rest_api_predict_role_arn
# The ARN of the IAM execution role for the REST API.

variable "diamonds_rest_api_predict_role_arn" {
    type = string
}