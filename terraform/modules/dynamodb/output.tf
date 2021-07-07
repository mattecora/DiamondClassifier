# diamonds_predictions_table_arn
# The ARN of the DynamoDB predictions table.

output "diamonds_predictions_table_arn" {
    value = aws_dynamodb_table.diamonds_predictions_table.arn
}