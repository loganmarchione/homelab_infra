################################################################################
### Create users
################################################################################

# Create IAM user
resource "aws_iam_user" "acme" {
  name = "acme"
}

# Create IAM user
resource "aws_iam_user" "postfixrelay" {
  name = "postfixrelay"
}

resource "aws_iam_access_key" "postfixrelay" {
  user = aws_iam_user.postfixrelay.name
}

################################################################################
### Route53+ACME
################################################################################

# Create a policy to allow updating DNS records
resource "aws_iam_policy" "acme" {
  name        = "ACME_updater"
  path        = "/"
  description = "Policy to allow ACME updating TXT records"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "ACME_updater",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:GetChange",
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
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/*",
        "Condition" : {
          "ForAllValues:StringEquals" : {
            "route53:ChangeResourceRecordSetsRecordTypes" : ["TXT"]
          }
        }
      }
    ]
  })
}

# Assign the policy
resource "aws_iam_user_policy_attachment" "acme" {
  user       = aws_iam_user.acme.name
  policy_arn = aws_iam_policy.acme.arn
}

################################################################################
### IAM billing access
################################################################################

resource "aws_iam_policy" "billing_fullaccess" {
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
          "billing:*",
          "cur:*",
          "freetier:*",
          "invoicing:*",
          "payments:*",
          "tax:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Assign the policy
resource "aws_iam_user_policy_attachment" "billing_fullaccess" {
  user       = "logan"
  policy_arn = aws_iam_policy.billing_fullaccess.arn
}
