resource "aws_api_gateway_rest_api" "diamonds_rest_api" {
    name = "diamonds-rest-api"
}

resource "aws_api_gateway_resource" "diamonds_rest_api_predict_resource" {
    rest_api_id = aws_api_gateway_rest_api.diamonds_rest_api.id
    parent_id   = aws_api_gateway_rest_api.diamonds_rest_api.root_resource_id
    path_part   = "predict-diamonds"
}

resource "aws_api_gateway_method" "diamonds_rest_api_predict_method" {
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id   = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method   = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "diamonds_rest_api_predict_integration" {
    rest_api_id             = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id             = aws_api_gateway_method.diamonds_rest_api_predict_method.resource_id
    http_method             = aws_api_gateway_method.diamonds_rest_api_predict_method.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.diamonds_lambda_predict_invoke_arn
    credentials             = var.diamonds_rest_api_predict_role_arn
}

resource "aws_api_gateway_deployment" "diamonds_rest_api_predict_deployment" {
    rest_api_id = aws_api_gateway_rest_api.diamonds_rest_api.id
    depends_on  = [
        aws_api_gateway_integration.diamonds_rest_api_predict_integration
    ]
}

resource "aws_api_gateway_stage" "diamonds_rest_api_predict_stage" {
    deployment_id = aws_api_gateway_deployment.diamonds_rest_api_predict_deployment.id
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    stage_name    = "test"
}