module "static_site_loganmarchione_dev" {
  source = "./modules/static_site"

  # The apex name of the site and the name of the S3 bucket to store the static files
  site_name   = "loganmarchione.dev"
  bucket_name = "loganmarchione-dev"

  # Since this is a static site, we probably don't need versioning, since our source files are stored in git
  bucket_versioning = "Disabled"
}
