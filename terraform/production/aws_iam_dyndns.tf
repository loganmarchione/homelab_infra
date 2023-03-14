################################################################################
### Dynamic DNS
################################################################################

########################################
### Create user
########################################

# Create IAM user for Dynamic DNS
resource "aws_iam_user" "dyndns" {
  name = "dyndns"
}

resource "aws_iam_access_key" "dyndns" {
  user = aws_iam_user.dyndns.name
}

output "dyndns_username" {
  value     = aws_iam_access_key.dyndns.id
  sensitive = true
}

output "dyndns_password" {
  value     = aws_iam_access_key.dyndns.secret
  sensitive = true
}

################################################################################
### Policy
################################################################################

# Create a policy to allow updating DNS records
resource "aws_iam_policy" "dyndns" {
  name        = "dyndns_updater"
  path        = "/"
  description = "Policy to allow dyndns updating A records"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "dyndns_updater",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListResourceRecordSets",
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/${aws_route53_zone.homelab_domain.zone_id}",
        "Condition" : {
          "ForAllValues:StringEquals" : {
            "route53:ChangeResourceRecordSetsRecordTypes" : ["A"]
          }
        }
      }
    ]
  })
}

# Assign the policy
resource "aws_iam_user_policy_attachment" "dyndns" {
  user       = aws_iam_user.dyndns.name
  policy_arn = aws_iam_policy.dyndns.arn
}
