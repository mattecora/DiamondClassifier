resource "aws_sagemaker_endpoint" "diamonds_predictor_endpoint" {
    name                 = "diamonds-predictor-endpoint"
    endpoint_config_name = "diamonds-predictor-endpoint-config"
}