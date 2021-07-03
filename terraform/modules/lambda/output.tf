output "diamonds_lambda_predict_arn" {
    value = aws_lambda_function.diamonds_lambda_predict.arn
}

output "diamonds_lambda_predict_invoke_arn" {
    value = aws_lambda_function.diamonds_lambda_predict.invoke_arn
}

output "diamonds_lambda_consume_arn" {
    value = aws_lambda_function.diamonds_lambda_consume.arn
}