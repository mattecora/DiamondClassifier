output "diamonds_firehose_role_arn" {
    value = aws_iam_role.diamonds_firehose_role.arn
}

output "diamonds_lambda_predict_role_arn" {
    value = aws_iam_role.diamonds_lambda_predict_role.arn
}

output "diamonds_lambda_consume_role_arn" {
    value = aws_iam_role.diamonds_lambda_consume_role.arn
}