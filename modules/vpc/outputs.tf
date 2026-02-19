output "vpc_id" {
  description = "생성된 VPC의 ID"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "ROSA가 배치될 프라이빗 서브넷 리스트"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}