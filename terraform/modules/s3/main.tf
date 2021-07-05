resource "aws_s3_bucket" "diamonds_firehose_bucket" {
    bucket = "aws-project-politomaster-firehose"
    acl    = "private"
}

resource "aws_s3_bucket" "diamonds_frontend_bucket" {
    bucket = "aws-project-politomaster-frontend-bucket"
    acl    = "public-read"

    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket_object" "diamonds_frontend_index_object" {
    bucket = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "index.html"
    source       = "${path.module}/../../../frontend/index.html"
    etag         = filemd5("${path.module}/../../../frontend/index.html")
    acl          = "public-read"
    content_type = "text/html"
}

resource "aws_s3_bucket_object" "diamonds_frontend_config_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "config.js"
    content      = templatefile("${path.module}/../../../frontend/config.js", { base_url = var.diamonds_rest_api_predict_base_url })
    etag         = md5(templatefile("${path.module}/../../../frontend/config.js", { base_url = var.diamonds_rest_api_predict_base_url }))
    acl          = "public-read"
    content_type = "text/javascript"
}

resource "aws_s3_bucket_object" "diamonds_frontend_script_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "script.js"
    source       = "${path.module}/../../../frontend/script.js"
    etag         = filemd5("${path.module}/../../../frontend/script.js")
    acl          = "public-read"
    content_type = "text/javascript"
}

resource "aws_s3_bucket_object" "diamonds_frontend_style_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "style.css"
    source       = "${path.module}/../../../frontend/style.css"
    etag         = filemd5("${path.module}/../../../frontend/style.css")
    acl          = "public-read"
    content_type = "text/css"
}