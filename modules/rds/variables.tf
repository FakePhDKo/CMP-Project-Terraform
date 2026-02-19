# 1. VPC ID (보안 그룹 생성용)
variable "vpc_id" {
  description = "VPC ID where the RDS security group will be created"
  type        = string
}

# 2. 프라이빗 서브넷 ID 리스트 (DB 서브넷 그룹용)
variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "db_password" {
  description = "Password received from root"
  type        = string
}