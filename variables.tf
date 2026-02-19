variable "aws_region" {
  description = "AWS 리전"
}

variable "vpc_cidr" {
  description = "VPC 대역"
}

variable "onprem_cidr" {
  description = "온프레미스 네트워크 대역"
}

variable "onprem_public_ip" {
  description = "온프레미스 VPN 게이트웨이 공인 IP"
}

variable "db_user" {
  description = "Database admin user"
  type        = string
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true  # 플랜/어플라이 로그에서 값을 숨깁니다.
}

variable "service_name" {
  description = "Name of the hybrid service"
  type        = string
}