# Task 1 — AWS VPC Setup (Networking & Subnetting)

This task involved creating a custom VPC with 2 public and 2 private subnets, an Internet Gateway, a NAT Gateway, and route tables for proper routing.

## 📌 CIDR Ranges Used
- **VPC:** `10.0.0.0/16`
- **Public Subnet 1:** `10.0.1.0/24`
- **Public Subnet 2:** `10.0.2.0/24`
- **Private Subnet 1:** `10.0.3.0/24`
- **Private Subnet 2:** `10.0.4.0/24`

Ranges are chosen for:
✔ Simplicity  
✔ Easy expansion  
✔ Clear separation between public and private networks  

---

# 📸 Screenshots

### VPC
![VPC](./screenshots/VPC%20create.png)

### Public and Private Subnets
![Public and Private Subnets](./screenshots/VPC%20Subnets.png)

### Route Tables
![Route Tables](./screenshots/Route%20Table.png)

### Public Route Table
![Public Route Table](./screenshots/VPC%20Public%20Route%20table%20config.png)

### Private Route Table
![Public Route Table](./screenshots/VPC%20Private%20Route%20Table%20Config.png)

### Internet Gateway
![IGW](./screenshots/VPC%20Internet%20Gateway.png)

### NAT Gateway
![NAT GW](./screenshots/NAT.png)

---

# 📁 Files Included
- `main.tf` — Terraform code to build the entire VPC
- Screenshot folder with all network components
