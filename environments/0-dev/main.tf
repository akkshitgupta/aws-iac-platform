
module "networking" {
  source = "../../modules/networking"

  vpc_cidr    = "10.0.0.0/16"
  environment = var.environment
}

module "security" {
  source = "../../modules/security"

  vpc_id      = module.networking.vpc_id
  environment = var.environment
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  environment       = var.environment
}

module "compute" {
  source = "../../modules/compute"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  security_group_id  = module.security.app_security_group_id
  target_group_arn   = module.load_balancer.target_group_arn
  instance_type      = "t3.micro"
  environment        = var.environment
}
