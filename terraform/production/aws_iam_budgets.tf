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
