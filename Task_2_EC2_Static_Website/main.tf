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

#################
# VARIABLES
#################
variable "region" {
  description = "AWS region to provision resources in"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
  default     = "Hitansh_Bhagatni_VPC"
}

variable "public_subnet_name" {
  description = "Name tag of the public subnet to place the EC2 in"
  type        = string
  default     = "Hitansh_Bhagatni_Public_Subnet_1"
}

variable "instance_type" {
  description = "EC2 instance type (Free Tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name for the key pair created in this config (if using)"
  type        = string
  default     = "Hitansh_Bhagatni"
}

variable "public_key" {
  description = "Public key string to create key pair (optional). Use file(\"~/.ssh/id_rsa.pub\") when running."
  type        = string
  default     = ""
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed for SSH access"
  type        = string
  default     = "152.58.56.118/32"
}

variable "resume_html" {
  description = "HTML content for the resume index page"
  type        = string
  default     = <<EOF
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Hitansh Bhagatani — Resume</title></head>
  <body>
    <h1>Hitansh Bhagatani</h1>
    <p>Email: hitanshbhagtani@gmail.com</p>
    <h2>Summary</h2>
    <p>Static resume hosted on Nginx (Task 2)</p>
  </body>
</html>
EOF
}

#################
# DATA LOOKUPS
#################
data "aws_vpc" "target" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

# Get a recent Amazon Linux AMI (will usually match Amazon Linux 2/2023)
data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-*", "amzn2-ami-hvm-*-x86_64-*", "amzn-2023-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#################
# RESOURCES
#################
# Create key pair if public_key provided
resource "aws_key_pair" "deployer" {
  count      = length(trimspace(var.public_key)) > 0 ? 1 : 0
  key_name   = var.key_name
  public_key = var.public_key
}

# Security group for web server
resource "aws_security_group" "web_sg" {
  name        = "Hitansh_Bhagatni_WebServer_SG"
  description = "Allow HTTP from anywhere and SSH from my IP"
  vpc_id      = data.aws_vpc.target.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Hitansh_Bhagatni_WebServer_SG"
  }
}

# EC2 instance
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  key_name = length(aws_key_pair.deployer) > 0 ? aws_key_pair.deployer[0].key_name : null

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
    resume_html = var.resume_html
  })

  tags = {
    Name = "Hitansh_Bhagatni_WebServer"
  }
}

#################
# OUTPUTS
#################
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}
