resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.user_id}-tfstate-bucket"

}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.user_id}-terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# s3 fe bucket
resource "aws_s3_bucket" "fe" {
  bucket = "${var.user_id}-fe-bucket"

  policy = templatefile("${path.module}/policy/s3-fe.json", {
    user_id = "${var.user_id}"
  })

}

resource "aws_s3_bucket_public_access_block" "fe" {
  bucket = aws_s3_bucket.fe.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "fe" {
  bucket = aws_s3_bucket.fe.bucket

  index_document {
    suffix = "index.html"
  }
}