# Default VPC & subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Amazon Linux 2023 AMI (x86_64)
data "aws_ami" "al2023" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group: SSH + ICMP
resource "aws_security_group" "p9_sg" {
  name        = "${var.project_name}-sg"
  description = "SSH and ICMP for P9"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP (all)"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# SSM role + instance profile
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "p9_ssm_role" {
  name = "${var.project_name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "p9_ssm_attach" {
  role       = aws_iam_role.p9_ssm_role.name
  policy_arn = data.aws_iam_policy.ssm_core.arn
}

resource "aws_iam_instance_profile" "p9_ssm_profile" {
  name = "${var.project_name}-ssm-profile"
  role = aws_iam_role.p9_ssm_role.name
}

# SSH keypair (generate locally + upload public key)
resource "tls_private_key" "p9_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "p9_pem" {
  filename             = "${path.module}/../ansible/p9-key.pem"
  content              = tls_private_key.p9_key.private_key_pem
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "aws_key_pair" "p9_key" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.p9_key.public_key_openssh
}

# Choose first default subnet
locals {
  default_subnet_id = data.aws_subnets.default.ids[0]
}

# EC2 instance
resource "aws_instance" "p9" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = local.default_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.p9_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.p9_ssm_profile.name
  key_name                    = aws_key_pair.p9_key.key_name

  tags = {
    Name        = var.project_name
    Project     = var.project_name
    Environment = "p9"
  }
}

# Ansible inventory file with host + key path
resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content  = <<EOT
[ec2]
${aws_instance.p9.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=./p9-key.pem ansible_python_interpreter=/usr/bin/python3
EOT

  depends_on = [
    aws_instance.p9,
    local_sensitive_file.p9_pem
  ]
}
