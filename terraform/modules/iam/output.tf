output "diamonds_firehose_role_arn" {
    value = aws_iam_role.diamonds_firehose_role.arn
}

output "diamonds_lambda_predict_role_arn" {
    value = aws_iam_role.diamonds_lambda_predict_role.arn
}

output "diamonds_lambda_consume_role_arn" {
    value = aws_iam_role.diamonds_lambda_consume_role.arn
}

output "diamonds_rest_api_predict_role_arn" {
    value = aws_iam_role.diamonds_rest_api_predict_role.arn
}

output "diamonds_data_producer_profile_name" {
    value = aws_iam_instance_profile.diamonds_data_producer_profile.name
}