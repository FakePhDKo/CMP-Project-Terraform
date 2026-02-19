# modules/alb/outputs.tf

output "alb_sg_id" {
  description = "The ID of the security group for the ALB"
  value       = aws_security_group.alb_sg.id 
}

output "target_group_arn" {
  description = "The ARN of the target group for the ASG to attach to"
  value       = aws_lb_target_group.tg.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}