# diamonds_lambda_predict_arn
# The ARN of the diamonds-endpoint-predict function.

output "diamonds_lambda_predict_arn" {
    value = aws_lambda_function.diamonds_lambda_predict.arn
}

# diamonds_lambda_predict_invoke_arn
# The invoke ARN of the diamonds-endpoint-predict function.

output "diamonds_lambda_predict_invoke_arn" {
    value = aws_lambda_function.diamonds_lambda_predict.invoke_arn
}

# diamonds_lambda_batch_arn
# The ARN of the diamonds-batch-predict function.

output "diamonds_lambda_batch_arn" {
    value = aws_lambda_function.diamonds_lambda_batch.arn
}

# diamonds_lambda_consume_arn
# The ARN of the diamonds-stream-consume function.

output "diamonds_lambda_consume_arn" {
    value = aws_lambda_function.diamonds_lambda_consume.arn
}