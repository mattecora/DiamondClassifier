# diamonds_firehose_bucket
# S3 bucket for storing unprocessed data from the Firehose delivery stream.

resource "aws_s3_bucket" "diamonds_firehose_bucket" {
    bucket = "aws-project-politomaster-firehose"
    acl    = "private"
}

# diamonds_frontend_bucket
# S3 bucket for serving the frontend's static files to the user's browser.

resource "aws_s3_bucket" "diamonds_frontend_bucket" {
    bucket = "aws-project-politomaster-frontend-bucket"
    acl    = "public-read"

    website {
        index_document = "index.html"
    }
}

# diamonds_frontend_index_object
# The index.html object to be stored in the frontend bucket.

resource "aws_s3_bucket_object" "diamonds_frontend_index_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "index.html"
    source       = "${path.module}/../../../frontend/index.html"
    etag         = filemd5("${path.module}/../../../frontend/index.html")
    acl          = "public-read"
    content_type = "text/html"
}

# diamonds_frontend_config_object
# The config.js object to be stored in the frontend bucket.

resource "aws_s3_bucket_object" "diamonds_frontend_config_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "config.js"
    content      = templatefile("${path.module}/../../../frontend/config.js", { base_url = var.diamonds_rest_api_predict_base_url })
    etag         = md5(templatefile("${path.module}/../../../frontend/config.js", { base_url = var.diamonds_rest_api_predict_base_url }))
    acl          = "public-read"
    content_type = "text/javascript"
}

# diamonds_frontend_script_object
# The script.js object to be stored in the frontend bucket.

resource "aws_s3_bucket_object" "diamonds_frontend_script_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "script.js"
    source       = "${path.module}/../../../frontend/script.js"
    etag         = filemd5("${path.module}/../../../frontend/script.js")
    acl          = "public-read"
    content_type = "text/javascript"
}

# diamonds_frontend_style_object
# The style.css object to be stored in the frontend bucket.

resource "aws_s3_bucket_object" "diamonds_frontend_style_object" {
    bucket       = aws_s3_bucket.diamonds_frontend_bucket.id
    key          = "style.css"
    source       = "${path.module}/../../../frontend/style.css"
    etag         = filemd5("${path.module}/../../../frontend/style.css")
    acl          = "public-read"
    content_type = "text/css"
}