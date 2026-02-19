# modules/alb/outputs.tf

output "target_group_arn" {
  value       = aws_lb_target_group.tg.arn
  description = "The ARN of the target group for the ASG to attach to"
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the load balancer"
}