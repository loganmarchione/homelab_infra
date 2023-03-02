resource "aws_budgets_budget" "monthly_cost_forecast" {
  name              = "total-budget-monthly"
  budget_type       = "COST"
  limit_amount      = "5"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = formatdate("YYYY-MM-DD_hh:mm", timestamp())

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email_logan]
  }

  lifecycle {
    ignore_changes = [
      # Let's ignore `time_period_start` changes because we use `timestamp()` to populate
      # this attribute. We only want `time_period_start` to be set upon initial provisioning.
      time_period_start,
    ]
  }
}
