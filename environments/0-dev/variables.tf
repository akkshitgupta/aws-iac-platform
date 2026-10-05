variable "aws_profile" {
  description = "AWS profile to use for authentication."
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS region in which infrastructure will be provisioned."
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}
