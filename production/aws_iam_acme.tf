################################################################################
### ACME
################################################################################

########################################
### Create user
########################################

resource "aws_iam_user" "acme" {
  name = "acme"
}

resource "aws_iam_access_key" "acme" {
  user = aws_iam_user.acme.name
}

########################################
### Create group
########################################

resource "aws_iam_group" "acme" {
  name = "acme"
  path = "/users/"
}

resource "aws_iam_user_group_membership" "acme" {
  user = aws_iam_user.acme.name

  groups = [
    aws_iam_group.acme.name
  ]
}

################################################################################
### Policy
################################################################################

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

resource "aws_iam_group_policy_attachment" "acme" {
  group      = aws_iam_group.acme.name
  policy_arn = aws_iam_policy.acme.arn
}
