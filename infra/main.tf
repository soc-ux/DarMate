data "aws_availability_zones" "available" {
  state = "available"
}

# 1. Module Reseau (VPC, 6 subnets multi-AZ, IGW, NAT Gateway)
module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  azs          = slice(data.aws_availability_zones.available.names, 0, 2)
}

# 2. Module Securite (sg-alb -> sg-app -> sg-db)
module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
}

# 3. Module Calcul (ALB public + Premiere EC2 en sous-reseau prive)
module "compute" {
  source                = "./modules/compute"
  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  app_private_subnet_id = module.network.app_private_subnet_ids[0]
  alb_security_group_id = module.security.alb_sg_id
  app_security_group_id = module.security.app_sg_id
  depends_on = [module.network]   
}
