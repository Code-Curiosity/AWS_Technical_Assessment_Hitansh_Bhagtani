variable "region" {
  type    = string
  default = "us-east-1" # billing metrics are available only in us-east-1
}

variable "alert_email" {
  description = "Email address to receive billing alerts (will receive a confirmation email)"
  type        = string
  default     = ""
}

variable "threshold_usd" {
  description = "Alarm threshold in USD. For ~₹100 use 1 (USD)."
  type        = number
  default     = 1
}

variable "period_seconds" {
  description = "Metric period in seconds (6 hours = 21600s)."
  type        = number
  default     = 21600
}

variable "alarm_name" {
  type    = string
  default = "Billing_Alert_Over_1USD"
}
