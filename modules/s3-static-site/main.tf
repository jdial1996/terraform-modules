resource "aws_s3_bucket" "site" {
  bucket = "${var.domain_name}.com"
}

resource "aws_s3_bucket_ownership_controls" "site" {
  bucket = aws_s3_bucket.site.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "site" {
  depends_on = [
    aws_s3_bucket_ownership_controls.site,
    aws_s3_bucket_public_access_block.site,
  ]

  bucket = aws_s3_bucket.site.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

data "template_file" "html" {
  template = file("templates/index.tpl")

  vars = {
    text = var.text
  }

}

resource "aws_s3_object" "site-index" {
  bucket       = aws_s3_bucket.site.id
  content      = data.template_file.html.rendered
  acl          = "public-read"
  content_type = "text/html"
  key          = "index.html"

  depends_on = [aws_s3_bucket.site, aws_s3_bucket_acl.site]
}

resource "aws_s3_object" "site-error" {
  bucket       = aws_s3_bucket.site.id
  source       = "templates/error.html"
  acl          = "public-read"
  content_type = "text/html"
  key          = "error.html"

  depends_on = [aws_s3_bucket.site, aws_s3_bucket_acl.site]
}

output "endpoint" {
  value = aws_s3_bucket_website_configuration.site.website_endpoint
}