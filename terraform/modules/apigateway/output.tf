# diamonds_rest_api_predict_base_url
# The base URL of the deployed REST API.

output "diamonds_rest_api_predict_base_url" {
    value = aws_api_gateway_stage.diamonds_rest_api_predict_stage.invoke_url
}

# diamonds_rest_api_arn
# The ARN of the deployed REST API.

output "diamonds_rest_api_arn" {
    value = aws_api_gateway_rest_api.diamonds_rest_api.arn
}