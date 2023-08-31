An opinionated Terraform module to create a static site:

* S3 bucket for site and logging
* S3 buckets are private
* Site file (e.g., HTML, CSS, etc...) can only be accessed through CloudFront (i.e., no direct access to file in S3)
