variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
  default     = "10.0.0.0/27"
}


variable "public_subnet_cidr" {
    description = "Bloco CIDR da Sub-rede publica"
    type = string
    default = "10.0.0.0/28"
}

variable "private_subnet_cidr" {
    description = "Bloco CIDR da Sub-rede privada"
    type = string
    default = "10.0.0.16/28"
}

variable "key_pair_name" {
  type    = string
  default = "terabite"  
}

variable "vpc_security_group_id" {
  description = "ID do Security Group da EC2"
  type        = string
  default = "gp-terabite"  
}


variable "subnet_ids" {
  description = "Lista de IDs de subnets"
  type        = list(string)
  default     = []
}