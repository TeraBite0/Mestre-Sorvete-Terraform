resource "aws_instance" "ec2_privada" {
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
    Name = "ec2-privada-terabite"
  }
}

output "private_instance_id" {
  value = aws_instance.ec2_privada.id
}