variable "ami_id" {
  type        = string
  description = "AMI ID for the instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet for the instance."
}

variable "vpc_id" {
  type        = string
  description = "VPC for the security group."
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDRs permitted to use SSH."
}

variable "allowed_app_cidrs" {
  type        = list(string)
  description = "CIDRs permitted to access the application."
}

variable "environment" {
  type        = string
  description = "Environment tag."
}
