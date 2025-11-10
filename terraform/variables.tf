variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "aws_profile" {
  type    = string
  default = "gg"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "project_name" {
  type    = string
  default = "p9-ansible-ec2"
}
