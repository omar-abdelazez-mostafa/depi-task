variable "aws_region" {
  description = "AWS region for the development environment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Existing VPC ID in which to place the instance."
  type        = string
}

variable "subnet_id" {
  description = "Existing public subnet ID with a route to an internet gateway."
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the selected AWS region."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name. The private key stays outside Terraform."
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR ranges allowed to access SSH. Set this to the operator's public IP /32."
  type        = list(string)
}

variable "allowed_app_cidrs" {
  description = "CIDR ranges allowed to access the application."
  type        = list(string)
}

variable "environment" {
  description = "Environment name used for resource tags."
  type        = string
  default     = "dev"
}
