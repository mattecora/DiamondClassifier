resource "aws_api_gateway_rest_api" "diamonds_rest_api" {
    name = "diamonds-rest-api"
}

resource "aws_api_gateway_resource" "diamonds_rest_api_predict_resource" {
    rest_api_id = aws_api_gateway_rest_api.diamonds_rest_api.id
    parent_id   = aws_api_gateway_rest_api.diamonds_rest_api.root_resource_id
    path_part   = "predict-diamonds"
}

resource "aws_api_gateway_method" "diamonds_rest_api_predict_post_method" {
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id   = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method   = "POST"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "diamonds_rest_api_predict_post_integration" {
    rest_api_id             = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id             = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method             = aws_api_gateway_method.diamonds_rest_api_predict_post_method.http_method
    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = var.diamonds_lambda_predict_invoke_arn
    credentials             = var.diamonds_rest_api_predict_role_arn
}

resource "aws_api_gateway_method" "diamonds_rest_api_predict_options_method" {
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id   = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method   = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_method_response" "diamonds_rest_api_predict_options_method_response" {
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id   = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method   = aws_api_gateway_method.diamonds_rest_api_predict_options_method.http_method
    status_code   = 200
    
    response_models = {
        "application/json" = "Empty"
    }

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin"  = true
    }
}

resource "aws_api_gateway_integration" "diamonds_rest_api_predict_options_integration" {
    rest_api_id = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method = aws_api_gateway_method.diamonds_rest_api_predict_options_method.http_method
    type        = "MOCK"

    request_templates = {
        "application/json" = jsonencode({ statusCode = 200 })
    }
}

resource "aws_api_gateway_integration_response" "diamonds_rest_api_predict_options_integration_response" {
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    resource_id   = aws_api_gateway_resource.diamonds_rest_api_predict_resource.id
    http_method   = aws_api_gateway_method.diamonds_rest_api_predict_options_method.http_method
    status_code   = 200

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST'",
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }

    depends_on = [
        aws_api_gateway_integration.diamonds_rest_api_predict_options_integration
    ]
}

resource "aws_api_gateway_deployment" "diamonds_rest_api_predict_deployment" {
    rest_api_id = aws_api_gateway_rest_api.diamonds_rest_api.id
    depends_on  = [
        aws_api_gateway_method.diamonds_rest_api_predict_post_method,
        aws_api_gateway_integration.diamonds_rest_api_predict_post_integration,
        aws_api_gateway_method.diamonds_rest_api_predict_options_method,
        aws_api_gateway_method_response.diamonds_rest_api_predict_options_method_response,
        aws_api_gateway_integration.diamonds_rest_api_predict_options_integration,
        aws_api_gateway_integration_response.diamonds_rest_api_predict_options_integration_response
    ]
}

resource "aws_api_gateway_stage" "diamonds_rest_api_predict_stage" {
    deployment_id = aws_api_gateway_deployment.diamonds_rest_api_predict_deployment.id
    rest_api_id   = aws_api_gateway_rest_api.diamonds_rest_api.id
    stage_name    = "test"
}