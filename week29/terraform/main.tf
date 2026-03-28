resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "dboy-hw-wk29-"
  force_destroy = true

  tags = {
    Jenkins = "True"
    Name    = "Week 29 Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_disable_public_access" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "polling_log" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "polling-log.png"
  source       = "../deliverables/polling-log.png"
  content_type = "image/png"
  etag         = filemd5("../deliverables/polling-log.png")
}

resource "aws_s3_object" "stages" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "stages.png"
  source       = "../deliverables/stages.png"
  content_type = "image/png"
  etag         = filemd5("../deliverables/stages.png")
}

resource "aws_s3_object" "last_webhook_successful" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "last-webhook-successful.png"
  source       = "../deliverables/last-webhook-successful.png"
  content_type = "image/png"
  etag         = filemd5("../deliverables/last-webhook-successful.png")
}

resource "aws_s3_object" "theo_signoff" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "theo-signoff-temp.png"
  source       = "../deliverables/theo-signoff-temp.png"
  content_type = "image/png"
  etag         = filemd5("../deliverables/theo-signoff-temp.png")
}
