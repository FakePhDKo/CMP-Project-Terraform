variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "service_name" {}
variable "instance_type" { default = "t3.medium" }
variable "iam_instance_profile" {} # 기존에 만든 IAM 프로필 사용
variable "db_url" {}               # RDS 접속 주소
variable "elb_sg_id" {}            # 기존 ALB 보안그룹 활용 (선택)