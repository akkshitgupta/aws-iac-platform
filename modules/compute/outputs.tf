output "autoscaling_group_name" {
  description = "Application Auto Scaling Group name"
  value       = aws_autoscaling_group.app.name
}

output "launch_template_id" {
  description = "Application Launch Template ID"
  value       = aws_launch_template.app.id
}
