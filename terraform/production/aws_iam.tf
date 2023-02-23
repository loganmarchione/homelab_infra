###
### Route53+ACME
###

# Create a policy to allow updating DNS records
# TODO
resource "aws_iam_policy" "acme_policy_certbot" {
  name        = "ACME_updater_certbot"
  path        = "/"
  description = "Policy to allow ACME updating for Certbot"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "ACME_updater",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:GetChange",
          "route53:ListHostedZones",
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# TODO
resource "aws_iam_policy" "acme_policy_lego" {
  name        = "ACME_updater_lego"
  path        = "/"
  description = "Policy to allow ACME updating for LEGO (used by cert.sh mainly on pfSense)"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "ACME_updater",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:GetChange",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*",
          "arn:aws:route53:::change/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZonesByName"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Create IAM user
resource "aws_iam_user" "acme_user" {
  name = "acme"
}

# Assign the policies created above to user
resource "aws_iam_user_policy_attachment" "attach_acme" {
  user       = aws_iam_user.acme_user.name
  policy_arn = aws_iam_policy.acme_policy_certbot.arn
}

resource "aws_iam_user_policy_attachment" "attach_lego" {
  user       = aws_iam_user.acme_user.name
  policy_arn = aws_iam_policy.acme_policy_lego.arn
}

###
### IAM billing access
###

# TODO
resource "aws_iam_policy" "billing_fullaccess_policy" {
  name        = "BillingFullAccess"
  path        = "/"
  description = "Policy to allow read/write access to billing"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "BillingFullAccess",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "aws-portal:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Assign the policy created above to user
resource "aws_iam_user_policy_attachment" "iam_attach_billing_fullaccess_policy" {
  user       = "logan"
  policy_arn = aws_iam_policy.billing_fullaccess_policy.arn
}
