variable "public_subnet_id" {
  description = "ID da sub-rede pública"
  type        = string
}

variable "private_subnet_id" {
  description = "ID da sub-rede privada"
  type        = string
}

variable "key_name" {
  description = "Chave-terabite"
  type        = string
}

variable "vpc_security_group_id" {
  description = "ID do grupo de segurança"
  type        = string
}