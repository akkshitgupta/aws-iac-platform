output "load_balancer_arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "load_balancer_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "Application target group ARN"
  value       = aws_lb_target_group.app.arn
}
