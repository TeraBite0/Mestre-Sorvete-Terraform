# Configuração de Provedor 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Módulo de Rede
module "network" {
  source = "./network"
  
  vpc_cidr         = "10.0.0.0/27"
  public_subnet_cidr  = "10.0.0.0/28"
  private_subnet_cidr = "10.0.0.16/28"
}

# Módulo de NAT Gateway
module "nat_gateway" {
  source = "./network"
  
  vpc_cidr = module.network.vpc_cidr
  
  subnet_ids  = [module.network.public_subnet_id]
}

# Módulo de ACL
module "acl" {
  source = "./network"
  
  vpc_cidr = module.network.vpc_cidr

  subnet_ids  = [
    module.network.public_subnet_id,
    module.network.private_subnet_id
  ]
}

# Módulo de Instâncias EC2
module "ec2_instances" {
  source               = "./modules/ec2"
  public_subnet_id     = module.network.public_subnet_id
  private_subnet_id    = module.network.private_subnet_id
  key_name             = module.network.key_name 
  vpc_security_group_id = module.network.ec2_sg
}



# Outputs do módulo EC2
output "public_instance_id" {
  value = module.ec2_instances.public_instance_id
}

output "private_instance_id" {
  value = module.ec2_instances.private_instance_id
}

output "key_name" {
  value = module.network.key_name 
}

