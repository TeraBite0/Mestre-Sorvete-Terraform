# EC2 privada para maáquina 01
resource "aws_instance" "ec2_privada_maquina_01" {
  ami                    = "ami-084568db4383264d4" 
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "ec2-privada-terabite-maquina-01"
  }
}

output "private_instance_maquina_01_id" {
  value = aws_instance.ec2_privada_maquina_01.id
}

# EC2 privada para máquina 02
resource "aws_instance" "ec2_privada_maquina_02" {
  ami                    = "ami-084568db4383264d4" 
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "ec2-privada-terabite-maquina-02"
  }
}

output "private_instance_maquina_02_id" {
  value = aws_instance.ec2_privada_maquina_02.id
}

# EC2 privada para banco de dados
resource "aws_instance" "ec2_privada_banco_01" {
  ami                    = "ami-084568db4383264d4" 
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "ec2-privada-terabite-banco-01"
  }
}

output "private_instance_banco_01_id" {
  value = aws_instance.ec2_privada_banco_01.id
}
