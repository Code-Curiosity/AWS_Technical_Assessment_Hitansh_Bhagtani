# Task 4 — Billing & Free Tier Monitoring (Terraform)

This folder contains Terraform code to create a CloudWatch billing alarm and an SNS topic + email subscription.

## What it creates

- SNS topic: `Hitansh_Billing_Alert_Topic`
- SNS email subscription: endpoint = your email (you must confirm)
- CloudWatch alarm: `Billing_Alert_Over_1USD` (EstimatedCharges > 1 USD)

## Important

- Billing metrics live only in **us-east-1 (N. Virginia)**. The provider defaults to `us-east-1`.
- Terraform will create the SNS subscription but you must **confirm** the subscription by clicking the link received via email.
- Do **not** commit `terraform.tfvars` containing your real email address. Use `terraform.tfvars.example` as a template.

## Usage (local)

1. Copy files to `Task_4_Billing/`.
2. Create a file `terraform.tfvars` (locally) with your email:

```hcl
alert_email = "your.email@example.com"
