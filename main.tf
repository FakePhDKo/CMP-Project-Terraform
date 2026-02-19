terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 최신 버전 권장
    }
  }
}

# 1. VPC 생성
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  service_name = var.service_name
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  service_name      = var.service_name
}

# 2. VPN 연결 (VPC ID를 넘겨받음)
module "vpn" {
  source           = "./modules/vpn"
  vpc_id           = module.vpc.vpc_id # vpc 모듈의 output 참조
  onprem_public_ip = var.onprem_public_ip
}

# 2. RDS 모듈: NAS를 대신할 안정적인 DB
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_password        = var.db_password
}

# 3. EC2 모듈: 우리 서비스가 올라갈 서버
module "ec2" {
  source            = "./modules/ec2"
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = var.vpc_cidr
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_ids = module.vpc.private_subnet_ids

  db_endpoint       = module.rds.db_endpoint
  target_group_arn   = module.alb.target_group_arn

  service_name      = var.service_name
  db_pass           = var.db_password
  db_user           = "adminuser" # 필요시 추가
  iam_instance_profile_name = "HybridServiceBrokerProfile"
}

module "beanstalk" {
  source               = "./modules/beanstalk"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnet_ids
  public_subnets       = module.vpc.public_subnet_ids
  service_name         = var.service_name
  iam_instance_profile = module.ec2.iam_instance_profile_name
  db_url               = "postgresql://${var.db_user}:${var.db_password}@${module.rds.db_endpoint}/hybrid_db"
  elb_sg_id            = module.alb.alb_sg_id
}