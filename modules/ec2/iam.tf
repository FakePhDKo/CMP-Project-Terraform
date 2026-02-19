# 1. EC2 서비스가 이 역할을 가질 수 있도록 허용 (Trust Relationship)
resource "aws_iam_role" "broker_role" {
  name = "HybridServiceBrokerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

# 2. 역할에 실제 권한 부여 (EC2 관리 권한)
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.broker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# 3. EC2 인스턴스에 적용할 '프로필' 생성
resource "aws_iam_instance_profile" "broker_profile" {
  name = "HybridServiceBrokerProfile"
  role = aws_iam_role.broker_role.name
}

# 4. 기존 aws_instance 리소스에 프로필 연결 (수정 필요)
# resource "aws_instance" "broker" {
#   ...
#   iam_instance_profile = aws_iam_instance_profile.broker_profile.name
#   ...
# }