# diamonds_predictor_endpoint_arn
# The ARN of the deployed Sagemaker endpoint.

output "diamonds_predictor_endpoint_arn" {
    value = aws_sagemaker_endpoint.diamonds_predictor_endpoint.arn
}