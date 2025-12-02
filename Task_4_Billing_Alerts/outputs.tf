output "sns_topic_arn" {
  description = "SNS Topic ARN used for billing alerts"
  value       = aws_sns_topic.billing_alerts.arn
}

output "alarm_name" {
  description = "CloudWatch billing alarm name"
  value       = aws_cloudwatch_metric_alarm.billing_alarm.alarm_name
}

output "subscription_endpoint" {
  description = "Email endpoint for subscription (needs confirmation)"
  value       = aws_sns_topic_subscription.email_sub.endpoint
}
