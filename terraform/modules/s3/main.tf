# diamonds_firehose_bucket
# S3 bucket for storing unprocessed data from the Firehose delivery stream.

resource "aws_s3_bucket" "diamonds_firehose_bucket" {
    bucket        = "aws-project-politomaster-firehose"
    acl           = "private"
    force_destroy = true
}

# diamonds_batch_bucket
# S3 bucket for performing batch predictions.

resource "aws_s3_bucket" "diamonds_batch_bucket" {
    bucket        = "aws-project-politomaster-batch"
    acl           = "private"
    force_destroy = true
}

# diamonds_batch_bucket_notification
# Notification for the diamonds-batch-predict function that a file was uploaded to the bucket.

resource "aws_s3_bucket_notification" "diamonds_batch_bucket_notification" {
    bucket = aws_s3_bucket.diamonds_batch_bucket.id

    lambda_function {
        lambda_function_arn = var.diamonds_lambda_batch_arn
        events              = [ "s3:ObjectCreated:*" ]
        filter_prefix       = "input/"
        filter_suffix       = ".csv"
    }
}

# diamonds_frontend_bucket
# S3 bucket for serving the frontend's static files to the user's browser.

resource "aws_s3_bucket" "diamonds_frontend_bucket" {
    bucket        = "aws-project-politomaster-frontend"
    acl           = "public-read"
    force_destroy = true

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