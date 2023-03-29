################################################################################
### Dynamic DNS
################################################################################

########################################
### Create user
########################################

resource "aws_iam_user" "dyndns" {
  name = "dyndns"
}

resource "aws_iam_access_key" "dyndns" {
  user = aws_iam_user.dyndns.name
}

########################################
### Create group
########################################

resource "aws_iam_group" "dyndns" {
  name = "dyndns"
  path = "/users/"
}

resource "aws_iam_user_group_membership" "dyndns" {
  user = aws_iam_user.dyndns.name

  groups = [
    aws_iam_group.dyndns.name
  ]
}

################################################################################
### Policy
################################################################################

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

resource "aws_iam_group_policy_attachment" "dyndns" {
  group      = aws_iam_group.dyndns.name
  policy_arn = aws_iam_policy.dyndns.arn
}
