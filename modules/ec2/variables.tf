# 루트 main.tf에서 넘겨주는 인자들을 여기서 선언해야 합니다.

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID for EC2 instance"
  type        = string
}

variable "db_endpoint" {
  description = "RDS endpoint for the application to connect"
  type        = string
}

variable "service_name" {
  description = "Name of the service for tagging"
  type        = string
}

variable "db_user" {
  default = "adminuser"
}

variable "db_pass" {
  type      = string
  sensitive = true
}

variable "ami_id" {
  description = "AMI-ID "
  type = string
  default = "ami-0389ea382ca31bd7f" # 서울 리전 기준
}

variable "iam_instance_profile_name" {
  type = string
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}
variable "target_group_arn" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR block for security group rules"
  type        = string
}