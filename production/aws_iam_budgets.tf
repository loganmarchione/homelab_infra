################################################################################
### IAM billing access
################################################################################

########################################
### Create group
########################################

resource "aws_iam_group" "logan" {
  name = "logan"
  path = "/users/"
}

resource "aws_iam_user_group_membership" "logan" {
  user = "logan"

  groups = [
    aws_iam_group.logan.name
  ]
}

################################################################################
### Policy
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

resource "aws_iam_group_policy_attachment" "logan" {
  group      = aws_iam_group.logan.name
  policy_arn = aws_iam_policy.billing_fullaccess.arn
}
