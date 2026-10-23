module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  allowed_app_cidrs = var.allowed_app_cidrs
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  environment       = var.environment
  instance_type     = var.instance_type
  key_name          = var.key_name
  subnet_id         = var.subnet_id
  vpc_id            = var.vpc_id
}
