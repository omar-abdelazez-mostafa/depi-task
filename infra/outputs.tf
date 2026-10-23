output "instance_id" {
  description = "ID of the application EC2 instance."
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "Public IPv4 address assigned to the application instance."
  value       = module.ec2.public_ip
}

output "security_group_id" {
  description = "ID of the application security group."
  value       = module.ec2.security_group_id
}

output "vpc_id" {
  description = "VPC used by the application instance."
  value       = local.vpc_id
}

output "subnet_id" {
  description = "Subnet used by the application instance."
  value       = local.subnet_id
}
