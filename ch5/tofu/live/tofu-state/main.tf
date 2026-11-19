provider "aws" {
  region  = "ap-southeast-2"
  profile = "dat-405398623290"
}

# Existing S3 bucket
resource "aws_s3_bucket" "tofu_state" {
  bucket        = "bucket1-405398623290-ap-southeast-2-an"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

# Enable S3 versioning
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tofu_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Keep public access blocked
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tofu_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Existing DynamoDB table
resource "aws_dynamodb_table" "tofu_locks" {
  name         = "fundamentals-of-devops-tofu-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

