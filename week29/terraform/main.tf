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
# add all files in deliverables directory
