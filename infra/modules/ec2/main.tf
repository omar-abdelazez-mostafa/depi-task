resource "aws_security_group" "app" {
  name        = "flask-app-${var.environment}"
  description = "Restricted access for the Flask application host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from approved operators"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "Application from approved clients"
    protocol    = "tcp"
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = var.allowed_app_cidrs
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "flask-app-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  tags = {
    Name        = "flask-app-${var.environment}"
    Environment = var.environment
  }
}
