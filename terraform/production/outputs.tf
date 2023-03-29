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

output "dyndns_username" {
  value       = aws_iam_access_key.dyndns.id
  description = "DynDNS username"
  sensitive   = true
}

output "dyndns_password" {
  value       = aws_iam_access_key.dyndns.secret
  description = "DynDNS password"
  sensitive   = true
}

output "postfixrelay_username" {
  value       = aws_iam_access_key.postfixrelay.id
  description = "SES username"
  sensitive   = true
}

# Need to get the SES SMTP password instead of the access key
output "postfixrelay_password" {
  value       = aws_iam_access_key.postfixrelay.ses_smtp_password_v4
  description = "SES password"
  sensitive   = true
}

