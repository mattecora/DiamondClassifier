resource "aws_s3_bucket" "diamonds_firehose_bucket" {
    bucket = "aws-project-politomaster-firehose"
    acl    = "private"
}