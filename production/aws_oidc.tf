################################################################################
### Module for OIDC provider
################################################################################

module "oidc_provider" {
  source = "github.com/terraform-aws-modules/terraform-aws-iam//modules/iam-github-oidc-provider?ref=v5.52.2"
}
