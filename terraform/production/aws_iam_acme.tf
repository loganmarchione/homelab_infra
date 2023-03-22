################################################################################
### ACME
################################################################################

########################################
### Create user
########################################

# Create IAM user for ACME
resource "aws_iam_user" "acme" {
  name = "acme"
}

resource "aws_iam_access_key" "acme" {
  user = aws_iam_user.acme.name
}

output "acme_username" {
  value       = aws_iam_access_key.acme.id
  description = "ACME username"
  sensitive   = true
}

output "acme_password" {
  value       = aws_iam_access_key.acme.secret
  description = "ACME password"
  sensitive   = true
}

################################################################################
### Policy
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
