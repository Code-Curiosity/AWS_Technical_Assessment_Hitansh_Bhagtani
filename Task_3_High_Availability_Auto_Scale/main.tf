terraform {
  required_providers {
    aws = { source = "hashicorp/aws" version = ">= 4.0" }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}

#################
# Data lookups
#################
data "aws_vpc" "target" {
  filter { name = "tag:Name"  values = [var.vpc_name] }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.target.id
  filter {
    name = "tag:Name"
    values = [var.public_subnet_name_1, var.public_subnet_name_2]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.target.id
  filter {
    name = "tag:Name"
    values = [var.private_subnet_name_1, var.private_subnet_name_2]
  }
}

data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-2023-*", "amzn2-ami-hvm-*-x86_64-*", "amzn-ami-hvm-*-x86_64-*"]
  }
  filter { name = "virtualization-type" values = ["hvm"] }
}

#################
# Security groups
#################
resource "aws_security_group" "alb_sg" {
  name        = "Hitansh_Bhagatni_ALB_SG"
  description = "Security group for ALB - allow HTTP from internet"
  vpc_id      = data.aws_vpc.target.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Hitansh_Bhagatni_ALB_SG" }
}

resource "aws_security_group" "asg_sg" {
  name        = "Hitansh_Bhagatni_ASG_SG"
  description = "Security group for ASG instances - allow HTTP from ALB"
  vpc_id      = data.aws_vpc.target.id

  ingress {
    description      = "Allow HTTP from ALB security group"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Hitansh_Bhagatni_ASG_SG" }
}

#################
# Launch template
#################
resource "aws_launch_template" "web_lt" {
  name_prefix   = "Hitansh_Bhagatni_Web_LT-"
  image_id      = data.aws_ami.amazon.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  user_data = base64encode(templatefile("${path.module}/user-data.tpl", {
    resume_message = var.resume_message
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Hitansh_Bhagatni_WebServer"
    }
  }
}

#################
# Target group + ALB + listener
#################
resource "aws_lb" "alb" {
  name               = "Hitansh-Bhagatni-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnet_ids.public.ids
  enable_deletion_protection = false
  tags = { Name = "Hitansh_Bhagatni_ALB" }
}

resource "aws_lb_target_group" "tg" {
  name     = "Hitansh-Bhagatni-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.target.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200-399"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "Hitansh_Bhagatni_TG" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

#################
# Auto Scaling Group
#################
resource "aws_autoscaling_group" "asg" {
  name                      = "Hitansh_Bhagatni_ASG"
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier       = data.aws_subnet_ids.private.ids
  target_group_arns         = [aws_lb_target_group.tg.arn]
  min_size                  = var.asg_min
  max_size                  = var.asg_max
  desired_capacity          = var.asg_desired
  health_check_type         = "ELB"
  health_check_grace_period = 60
  force_delete              = false
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "Hitansh_Bhagatni_ASG_Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#################
# Outputs
#################
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}
