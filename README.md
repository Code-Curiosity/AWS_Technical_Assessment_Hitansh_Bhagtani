# AWS Technical Assessment – Hitansh Bhagatni

This repository contains solutions for **all 5 tasks** of the AWS Cloud Infrastructure Assessment. Each task is placed in its own folder with Terraform code, setup scripts, detailed explanations, and required screenshots.

All AWS resources were **terminated after completion** to avoid any ongoing billing.

---

## 📂 Folder Structure

```
Task_1_VPC/
  - VPC, Subnets, Route Tables, IGW, NAT Gateway
  - Terraform code + screenshots + explanation

Task_2_EC2_Static_Site/
  - EC2 instance in public subnet
  - Nginx static resume hosting
  - Terraform optional + screenshots + explanation

Task_3_High_Availability_Auto_Scale/
  - Application Load Balancer (ALB)
  - Auto Scaling Group (ASG) in private subnets
  - Launch Template + user-data
  - Terraform code + screenshots + explanation

Task_4_Billing_Alerts/
  - CloudWatch Billing Alarm (₹100)
  - Free Tier Usage Alerts enabled
  - Screenshots + explanation

Task_5_Architecture_Diagram/
  - Scalable 10,000-user architecture (draw.io)
  - PNG/PDF architecture diagram + explanation
```

## 🧩 Navigation Guide

Each task folder includes:

* A detailed `README.md`
* `main.tf` (Terraform code)
* Extra files (user-data, variables.tf)
* `screenshots/` folder containing images referenced in the README

---

## 🔒 Resource Cleanup

All AWS resources created for this assessment were terminated:

* EC2 instances
* Auto Scaling Groups
* Load Balancers
* NAT Gateway & EIP
* VPC
* CloudWatch alarms

---

## 📞 Contact

For any clarification related to this submission:

**Hitansh Bhagatni**
📧 *[hitanshbhagtani@gmail.com](mailto:hitanshbhagtani@gmail.com)*
