# static_site

## Explanation

An opinionated Terraform module to create a static site:

* Separate S3 buckets for site files (e.g., HTML, CSS, etc...) and logging
* S3 buckets are private
* Logs move to Standard IA after 30 days and are expired after 365
* Site files (e.g., HTML, CSS, etc...) can only be accessed through CloudFront (i.e., no direct access to files in S3)
* Creates an ACM certificate for `site_name` and `*.site_name` (i.e., for subdomains like `www.site_name`)
* Validates the ACM certificate using Route53 DNS
