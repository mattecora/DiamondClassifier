output "diamonds_firehose_bucket_arn" {
    value = aws_s3_bucket.diamonds_firehose_bucket.arn
}

output "diamonds_frontend_bucket_endpoint" {
    value = aws_s3_bucket.diamonds_frontend_bucket.website_endpoint
}