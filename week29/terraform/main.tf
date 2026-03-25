resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "dboy-hw-wk29-"
  force_destroy = true

  tags = {
    Jenkins = "True"
    Name    = "Week 29 Bucket"
  }
}

# add all files in deliverables directory
