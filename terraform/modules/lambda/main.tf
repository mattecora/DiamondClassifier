# diamonds_lambda_predict_bundle
# The ZIP bundle of the diamonds-endpoint-predict function.

data "archive_file" "diamonds_lambda_predict_bundle" {
    type        = "zip"
    source_dir  = "${path.module}/../../../lambda/diamonds-endpoint-predict/"
    output_path = "${path.module}/../../../lambda/diamonds-endpoint-predict.zip"
}

# diamonds_lambda_consume_bundle
# The ZIP bundle of the diamonds-stream-consume function.

data "archive_file" "diamonds_lambda_consume_bundle" {
    type        = "zip"
    source_dir  = "${path.module}/../../../lambda/diamonds-stream-consume/"
    output_path = "${path.module}/../../../lambda/diamonds-stream-consume.zip"
}

# diamonds_lambda_predict
# The diamonds-endpoint-predict Lambda function.

resource "aws_lambda_function" "diamonds_lambda_predict" {
    function_name    = "diamonds-endpoint-predict"
    role             = var.diamonds_lambda_predict_role_arn
    filename         = data.archive_file.diamonds_lambda_predict_bundle.output_path
    source_code_hash = data.archive_file.diamonds_lambda_predict_bundle.output_base64sha256
    runtime          = "python3.8"
    handler          = "main.predict"
    timeout          = 30
}

# diamonds_lambda_consume
# The diamonds-stream-consume Lambda function.

resource "aws_lambda_function" "diamonds_lambda_consume" {
    function_name    = "diamonds-stream-consume"
    role             = var.diamonds_lambda_consume_role_arn
    filename         = data.archive_file.diamonds_lambda_consume_bundle.output_path
    source_code_hash = data.archive_file.diamonds_lambda_consume_bundle.output_base64sha256
    runtime          = "python3.8"
    handler          = "main.consume"
    timeout          = 30
}

# diamonds_lambda_consume_stream_mapping
# The input mapping for the diamonds-stream-consume function.

resource "aws_lambda_event_source_mapping" "diamonds_lambda_consume_stream_mapping" {
    event_source_arn  = var.diamonds_data_stream_arn
    function_name     = aws_lambda_function.diamonds_lambda_consume.arn
    starting_position = "LATEST"
}