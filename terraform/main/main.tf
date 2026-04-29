module "vpc" {
  source = "../modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "security_group" {
  source = "../modules/security_group"

  vpc_id = module.vpc.vpc_id
}


module "ec2" {
  source = "../modules/ec2"

  subnet_id      = module.vpc.public_subnet_id
  sg_id          = module.security_group.sg_id
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
}

