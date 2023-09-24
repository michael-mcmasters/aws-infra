resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-unique-bucket-name-chicken-dinner-winner-winner-010"
}

resource "aws_s3_account_public_access_block" "website_bucket" {
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# locals {
#   folder_files = flatten([for d in flatten(fileset("${path.module}/Directories/*", "*")) : trim( d, "../") ])
# }

# resource "aws_s3_object" "this" {
#   for_each = { for idx, file in local.folder_files : idx => file }

#   bucket       = aws_s3_bucket.website_bucket.id
#   key          = "/Directories/${each.value}"
#   source       = "${path.module}/Directories/${each.value}"
#   etag = "${path.module}/Directories/${each.value}"
# }

# resource "aws_s3_object" "website_bucket" {
#   bucket       = aws_s3_bucket.website_bucket.id
#   key          = "website"          # The object name (key)
#   source       = "../index.html"    # Where the source code is
#   # source       = "../frontend"    # Where the source code is
#   content_type = "text/html"
# }

# resource "aws_s3_bucket_object" "website_bucket" {
#   # for_each = fileset("/home/pawan/Documents/Projects/", "*")
#   for_each = fileset("../frontend/", "*")

#   bucket = aws_s3_bucket.website_bucket.id
#   key    = each.value
#   source = "../frontend/${each.value}"
#   # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
#   etag   = filemd5("../frontend/${each.value}")
# }

resource "aws_cloudfront_distribution" "cdn_static_site" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "build/index.html"   # The S3 object name (key) (I'm pretty sure)
  comment             = "my cloudfront in front of the s3 bucket"

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "my-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  default_cache_behavior {
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-s3-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true 
  }
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "cloudfront OAC"
  description                       = "description of OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn_static_site.domain_name
}

# data "aws_iam_policy_document" "website_bucket" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.website_bucket.arn}/*"]
#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }
#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceArn"
#       values   = [aws_cloudfront_distribution.cdn_static_site.arn]
#     }
#   }
# }

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  
  # policy = data.aws_iam_policy_document.website_bucket.json
  
  # TODO: The AWS console told me to use this iam policy. Not sure if it will work, but commented the above out and replaced it with this.
  # But then get an error that the IAM role already exists. So need to fix that.
  policy = jsonencode({
  "Version": "2008-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-unique-bucket-name-chicken-dinner-winner-winner-010/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::959175409202:distribution/E1U8S2WY5ZR13"
        }
      }
    }
  ]
})
}



# What it actually is
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "cloudfront.amazonaws.com"
#             },
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::my-unique-bucket-name-chicken-dinner-winner-winner-010/*",
#             "Condition": {
#                 "StringEquals": {
#                     "aws:SourceArn": "arn:aws:cloudfront::959175409202:distribution/E1U8S2WY5ZR13"
#                 }
#             }
#         }
#     ]
# }


# {
#         "Version": "2008-10-17",
#         "Id": "PolicyForCloudFrontPrivateContent",
#         "Statement": [
#             {
#                 "Sid": "AllowCloudFrontServicePrincipal",
#                 "Effect": "Allow",
#                 "Principal": {
#                     "Service": "cloudfront.amazonaws.com"
#                 },
#                 "Action": "s3:GetObject",
#                 "Resource": "arn:aws:s3:::my-unique-bucket-name-chicken-dinner-winner-winner-010/*",
#                 "Condition": {
#                     "StringEquals": {
#                       "AWS:SourceArn": "arn:aws:cloudfront::959175409202:distribution/E1U8S2WY5ZR13"
#                     }
#                 }
#             }
#         ]
#       }