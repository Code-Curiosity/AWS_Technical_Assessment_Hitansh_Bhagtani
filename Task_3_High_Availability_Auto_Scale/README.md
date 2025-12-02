# Task 3 — High Availability + Auto Scaling

## Purpose
Provision an HA web tier: an internet-facing ALB in public subnets routing to a Target Group. The Target Group is served by EC2 instances launched from a Launch Template inside an Auto Scaling Group spanning two private subnets (multi-AZ). Instances run Nginx via user-data and serve a simple static page.

## Files
- `main.tf`        — Terraform resources (ALB, TG, Launch Template, ASG, Security Groups)
- `user-data.tpl`  — script to install Nginx and write a simple page
- `variables.tf`   — variable definitions
- `terraform.tfvars.example` — example variable overrides

## Notes
- The Terraform looks up an existing VPC and subnets by tag Name. Ensure your VPC and subnets exist and use the same Name tags used here (or update variables).
- This configuration expects you created the VPC/subnets/NAT earlier (Task 1).
- The ASG instances live in private subnets; ALB lives in public subnets.
- Do NOT upload any private key or actual terraform.tfvars containing your IPs or secrets to GitHub.

---

# 📸 Screenshots

### EC2 Auto Scale Group

![Auto Scale Group](./screenshots/EC2%20ASG%20Overview.png)

### EC2 ASG Instance Details

![ASG instance details](./screenshots/EC2%20ASG%20instance%20details.pngn)

### Target Groups

![Target Group](./screenshots/EC2%20TG%20Registered%20target.png)

### High Availablity Server

![HA Server](./screenshots/Screenshot%202025-12-02%20165603.png)

---

## How to run (optional)
1. Copy files into `Task_3_HA_ASG/`.
2. Edit variables if your Name tags differ.
3. Run:
```bash
terraform init
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"
