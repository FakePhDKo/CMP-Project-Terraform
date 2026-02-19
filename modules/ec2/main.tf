resource "aws_security_group" "eice_sg" {
  name        = "${var.service_name}-eice-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # VPC 내부로만 나감
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-service-sg"
  vpc_id = var.vpc_id

  # 인바운드 규칙 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 인바운드 규칙 (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.eice_sg.id]
  }

  # 아웃바운드 규칙 (모든 통신 허용)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 1. 시작 템플릿 (서버 설정 정의)
resource "aws_launch_template" "broker_lt" {
  name_prefix   = "hybrid-broker-lt-"
  image_id      = var.ami_id
  instance_type = "t3.medium"

  # 이전에 만든 IAM 프로필 연결 (마스터 키 권한)
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false # 프라이빗 서브넷에 두기 위해 false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "DATABASE_URL=postgresql://${var.db_user}:${var.db_pass}@${var.db_endpoint}/hybrid_db" >> /etc/environment
              # 여기에 애플리케이션 실행 스크립트 추가
              EOF
  )
}

# 2. 오토 스케일링 그룹 (서버 자동 생성 및 유지)
resource "aws_autoscaling_group" "broker_asg" {
  desired_capacity    = 2 # 평소에 2대 유지
  max_size            = 4 # 부하 시 최대 4대
  min_size            = 1
  
  vpc_zone_identifier = var.private_subnet_ids # 프라이빗 서브넷에 배치

  target_group_arns = [var.target_group_arn] # ALB와 연결

  launch_template {
    id      = aws_launch_template.broker_lt.id
    version = "$Latest"
  }
}

resource "aws_ec2_instance_connect_endpoint" "main" {
  subnet_id          = var.private_subnet_ids[0]
  security_group_ids = [aws_security_group.eice_sg.id]
  tags = { Name = "${var.service_name}-eice" }
}