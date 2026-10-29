variable "aws_region" {
  description = "AWS region for the development environment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Existing VPC ID. Leave null to create a small public VPC."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Existing public subnet ID. Leave null to create a public subnet."
  type        = string
  default     = null
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the selected AWS region. When null, a current Ubuntu Jammy (22.04 LTS) AMI is resolved automatically."
  type        = string
  default     = null
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

variable "create_network" {
  description = "Create a minimal VPC, public subnet, internet gateway, and route table when existing IDs are not supplied."
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR for the managed VPC."
  type        = string
  default     = "10.42.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR for the managed public subnet."
  type        = string
  default     = "10.42.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the managed public subnet."
  type        = string
  default     = null
}
