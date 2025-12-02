variable "region" { type = string, default = "eu-north-1" }
variable "vpc_name" { type = string, default = "Hitansh_Bhagatni_VPC" }

variable "public_subnet_name_1" { type = string, default = "Hitansh_Bhagatni_Public_Subnet_1" }
variable "public_subnet_name_2" { type = string, default = "Hitansh_Bhagatni_Public_Subnet_2" }

variable "private_subnet_name_1" { type = string, default = "Hitansh_Bhagatni_Private_Subnet_1" }
variable "private_subnet_name_2" { type = string, default = "Hitansh_Bhagatni_Private_Subnet_2" }

variable "instance_type" { type = string, default = "t3.micro" }
variable "key_name" { type = string, default = "Hitansh_Bhagatni" }

variable "resume_message" { type = string, default = "Welcome to HA Nginx Server (Auto Scaling) - Hitansh Bhagatni" }

variable "asg_min" { type = number, default = 1 }
variable "asg_desired" { type = number, default = 2 }
variable "asg_max" { type = number, default = 3 }
