terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

#######################
# SNS Topic + Subscription
#######################
resource "aws_sns_topic" "billing_alerts" {
  name = "Hitansh_Billing_Alert_Topic"
  tags = {
    Name = "Hitansh_Billing_Alert_Topic"
  }
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.billing_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email

  # note: the subscription must be confirmed by clicking the link in the email
  # Terraform will create the subscription object but we must confirm it manually.
}

#######################
# CloudWatch Billing Alarm
# NOTE: Billing metrics are available only in us-east-1
#######################
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name          = var.alarm_name
  alarm_description   = "Alert when EstimatedCharges exceed ${var.threshold_usd} USD"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = var.period_seconds
  statistic           = "Maximum"
  threshold           = var.threshold_usd
  treat_missing_data  = "notBreaching"

  alarm_actions = [
    aws_sns_topic.billing_alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.billing_alerts.arn
  ]

  tags = {
    Name = "Hitansh_Billing_Alarm"
  }
}
