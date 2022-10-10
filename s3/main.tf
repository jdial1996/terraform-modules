#  Our domain name is the bucket name since S3 buckets need to be globally unique


resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.domain_name}.com"
  acl = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
}
resource "aws_s3_bucket_website_configuration" "www_bucket" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}



resource "aws_s3_bucket" "sub_domainwebsite_bucket" {
  bucket = "www.${var.domain_name}.com"
  acl = "public-read"
  policy = data.aws_iam_policy_document.subdomain_website_policy.json


}


resource "aws_s3_bucket_website_configuration" "sub_domain" {
  bucket = aws_s3_bucket.sub_domainwebsite_bucket.bucket

    redirect_all_requests_to {
        host_name = "www.${var.domain_name}.com"
    }
}

output "website_endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}

# Policy documrnt to make access to all objects in the bucket public
data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.domain_name}.com/*"
    ]
  }
}

data "aws_iam_policy_document" "subdomain_website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::www.${var.domain_name}.com/*"
    ]
  }
}

# Create DNS records so we do not have to access the website using the long S3 URL 

# resource "aws_route53_zone" "primary" {
#   name = "${var.domain_name}.com"
# }

resource "aws_route53_record" "www" {
  zone_id = ""
  name = "www"
  type = "A"
  alias {
    name = aws_s3_bucket.website_bucket.website_domain
    zone_id = aws_s3_bucket.website_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}