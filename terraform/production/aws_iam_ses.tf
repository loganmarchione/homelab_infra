################################################################################
### SES
################################################################################

########################################
### Create user
########################################

# Create IAM user for postfixrelay
resource "aws_iam_user" "postfixrelay" {
  name = "postfixrelay"
}

resource "aws_iam_access_key" "postfixrelay" {
  user = aws_iam_user.postfixrelay.name
}



################################################################################
### Policy
################################################################################

resource "aws_iam_policy" "ses_send_only" {
  name        = "SESSendOnly"
  path        = "/"
  description = "Policy to allow sending email via SES"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "SESSendOnly",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ses:SendRawEmail"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Assign the policy
resource "aws_iam_user_policy_attachment" "ses_send_only" {
  user       = aws_iam_user.postfixrelay.name
  policy_arn = aws_iam_policy.ses_send_only.arn
}
