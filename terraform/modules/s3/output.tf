# diamonds_firehose_bucket_arn
# The ARN of the Firehose bucket.

output "diamonds_firehose_bucket_arn" {
    value = aws_s3_bucket.diamonds_firehose_bucket.arn
}

# diamonds_frontend_bucket_endpoint
# The HTTP endpoint of the frontend bucket-hosted website.

output "diamonds_frontend_bucket_endpoint" {
    value = aws_s3_bucket.diamonds_frontend_bucket.website_endpoint
}