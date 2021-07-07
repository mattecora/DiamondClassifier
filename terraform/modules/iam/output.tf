# diamonds_firehose_role_arn
# The ARN of the IAM execution role for the Firehose delivery stream.

output "diamonds_firehose_role_arn" {
    value = aws_iam_role.diamonds_firehose_role.arn
}

# diamonds_lambda_predict_role_arn
# The ARN of the IAM execution role for the diamonds-endpoint-predict function.

output "diamonds_lambda_predict_role_arn" {
    value = aws_iam_role.diamonds_lambda_predict_role.arn
}

# diamonds_lambda_batch_role_arn
# The ARN of the IAM execution role for the diamonds-batch-predict function.

output "diamonds_lambda_batch_role_arn" {
    value = aws_iam_role.diamonds_lambda_batch_role.arn
}

# diamonds_lambda_consume_role_arn
# The ARN of the IAM execution role for the diamonds-stream-consume function.

output "diamonds_lambda_consume_role_arn" {
    value = aws_iam_role.diamonds_lambda_consume_role.arn
}

# diamonds_data_producer_profile_name
# The name of the IAM profile for the data producer instance.

output "diamonds_data_producer_profile_name" {
    value = aws_iam_instance_profile.diamonds_data_producer_profile.name
}