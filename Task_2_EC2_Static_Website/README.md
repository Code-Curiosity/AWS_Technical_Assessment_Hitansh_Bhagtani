# Task 2 — EC2 Static Website (Nginx)

## Purpose

This folder contains Terraform IaC and a user-data script to provision a single EC2 instance that hosts a static resume using Nginx. The configuration expects the VPC and public subnet created in Task 1 (Name tags used).

## Files

- `main.tf`            - Terraform configuration to create the EC2 instance and security group
- `user-data.sh.tpl`   - user-data template that installs Nginx and drops the resume HTML into nginx webroot

## Important Notes

- The Terraform looks up an existing VPC by tag **Name = `Hitansh_Bhagatni_VPC`** and a public subnet by tag **Name = `Hitansh_Bhagatni_Public_Subnet_1`**.
- This Terraform **uses existing key pair** named `Hitansh_Bhagatni_Key`. Do NOT set `public_key` — the configuration expects that we have already created the key pair in AWS console and downloaded the `.pem`. The SSH rule is restricted to my IP: `152.58.56.118/32`.

---

# 📸 Screenshots

### EC2 Instance
![EC2](./screenshots/EC2%20Instance%20detailss.png)

### EC2 Instance Security
![EC2 Instance Security](./screenshots/EC2%20Instance%20Security%20Details.png)

### EC2 Auto Scale Group
![Auto Scale Group](./screenshots/EC2%20ASG%20Overview.png)

### EC2 ASG Instance Details
![ASG instance details](./screenshots/EC2%20ASG%20instance%20details.pngn)

### EC2 Load Balancer
![Load Balancer](./screenshots/EC2%20LoaBalancer%20Details.png)

### Launch Template Details
![LT](./screenshots/EC2%20Launch%20Template.png)

### Target Groups
![Target Group](./screenshots/EC2%20TG%20Registered%20target.png)

### Web Launch Template
![Target Group](./screenshots/Screenshot%202025-12-02%20at%2016-13-52%20EC2%20eu-north-1.png)

### Resume Hosting on EC2
![Target Group](./screenshots/Screenshot%202025-12-02%20153820.png)

---


## How to use (optional — only if you want to run Terraform)

1. Copy files into `Task_2_EC2_Static_Website/`.
2. Create a `terraform.tfvars` (example below) or pass -var variables.
3. Run:

```bash
terraform init
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"
