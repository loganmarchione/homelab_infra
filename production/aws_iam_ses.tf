################################################################################
### SES
################################################################################

########################################
### Create user
########################################

resource "aws_iam_user" "postfixrelay" {
  name = "postfixrelay"
}

resource "aws_iam_access_key" "postfixrelay" {
  user = aws_iam_user.postfixrelay.name
}

########################################
### Create group
########################################

resource "aws_iam_group" "postfixrelay" {
  name = "postfixrelay"
  path = "/users/"
}

resource "aws_iam_user_group_membership" "postfixrelay" {
  user = aws_iam_user.postfixrelay.name

  groups = [
    aws_iam_group.postfixrelay.name
  ]
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
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "postfixrelay" {
  group      = aws_iam_group.postfixrelay.name
  policy_arn = aws_iam_policy.ses_send_only.arn
}
