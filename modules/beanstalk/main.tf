# 1. Beanstalk 애플리케이션 (논리적 그룹)
resource "aws_elastic_beanstalk_application" "app" {
  name = "${var.service_name}-app"
}

# 2. Beanstalk 환경 (실제 리소스)
resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.service_name}-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.9.3 running Python 3.11"

  # --- VPC 설정 ---
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.private_subnets) # 인스턴스는 프라이빗에
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.public_subnets)  # 로드밸런서는 퍼블릭에
  }

  # --- 인스턴스 설정 ---
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.iam_instance_profile
  }

  # --- 환경 변수 (중요: 파이썬 코드가 읽을 DB 정보) ---
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = var.db_url
  }

  # --- 로드밸런서 설정 (Health Check 경로) ---
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/health"
  }
}