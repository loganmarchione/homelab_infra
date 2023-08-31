# static_site

## Explanation

An opinionated Terraform module to create a static site:

* Separate S3 buckets for site files (e.g., HTML, CSS, etc...) and logging
* S3 buckets are private
* Site files (e.g., HTML, CSS, etc...) can only be accessed through CloudFront (i.e., no direct access to files in S3)
