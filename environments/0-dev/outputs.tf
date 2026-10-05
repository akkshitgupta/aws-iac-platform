# ===== Networking Outputs =====
output "vpc_id" {
  description = "Production VPC ID"
  value       = module.networking.vpc_id
}
output "public_subnet_ids" {
  description = "Production public subnet IDs"
  value       = module.networking.public_subnet_ids
}
output "private_subnet_ids" {
  description = "Production private subnet IDs"
  value       = module.networking.private_subnet_ids
}

# ===== Security Group Outputs =====
output "alb_security_group_id" {
  value = module.security.alb_security_group_id
}
output "app_security_group_id" {
  value = module.security.app_security_group_id
}
output "database_security_group_id" {
  value = module.security.database_security_group_id
}
