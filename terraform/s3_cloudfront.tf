## Bucket for Static Website
resource "aws_s3_bucket" "website" {
  bucket = "juwusupercoolsneakers"
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "sneaker-shop.html"
  }

  error_document {
    key = "sneaker-shop.html"
  }
}

# Upload HTML File
resource "aws_s3_object" "html" {
  bucket       = aws_s3_bucket.website.id
  key          = "sneaker-shop.html"
  source       = "${path.module}/../Frontend/sneaker-shop.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/../Frontend/sneaker-shop.html")
}