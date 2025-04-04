provider "aws" {
    region = "us-west-2"
}

resource "aws_s3_bucket" "next.js_bucket" {
  bucket = "cl-next-js-bucket"
}

resource "aws_s3_bucket_ownership_controls" "next.js_bucket_ownership_controls" {
  bucket = aws_s3_bucket.nextjs_bucket.id 
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_access_block" {
  bucket = aws_s3_bucket.nextjs_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
}

resource "aws_bucket_acl" "nextjs_bucket_acl" {

    depends_on = [ 
        aws_s3_bucket_ownership_controls.nextjs,
        aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block 
        ]
    bucket = aws_s3_bucket.next.js_bucket.id
    acl    = "public-read"
  
}

resource "aws_s3_bucket_policy" "next.js.bucket_policy" {
    bucket = aws_s3_bucket.next.js_bucket.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "PublicReadGetObject",
                Effect = "Allow",
                Principal = "*",
                Action = "s3:GetObject",
                Resource = "${aws_s3_bucket.next.js_bucket.arn}/*"
            }
        ]
    })
  
}