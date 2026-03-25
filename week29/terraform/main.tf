# We're Okay to Allow Public Access to the Bucket
# aws_s3_bucket

resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "dboy_hw_wk29_"
  force_destroy = true

  tags = {
    Jenkins = "True"
    Name    = "Week 29 Bucket"
  }
}

# add all files in deliverables directory
