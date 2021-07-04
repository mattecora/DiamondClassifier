output "diamonds_predictor_endpoint_arn" {
    value = aws_sagemaker_endpoint.diamonds_predictor_endpoint.arn
}