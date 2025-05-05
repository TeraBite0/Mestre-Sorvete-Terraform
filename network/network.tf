# Criação da VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-terabite-01"
  }
}

# Sub-rede pública
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "subrede-publica-terabite"
  }
}

# Sub-rede privada
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "subrede-privada-terabite"
  }
}

# ACL da rede
resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "acl-terabite"
  }
}

# Permissão de saída na ACL
resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Permitir entrada na porta 22 (SSH)
resource "aws_network_acl_rule" "allow_ssh_inbound" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Permitir resposta de conexões: portas efêmeras de entrada
resource "aws_network_acl_rule" "allow_ephemeral_inbound" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_association" "public_subnet_acl" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_network_acl_association" "private_subnet_acl" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.private_subnet.id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-terabite"
  }
}

# NAT Gateway EIP
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "eip-nat-terabite"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  
  tags = {
    Name = "nat-terabite"
  }
}

# Tabela de rotas pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id  
  }

  tags = {
    Name = "rt-publica"
  }
}

# Tabela de rotas privada
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "rt-privada"
  }
}

# Associação da tabela de rotas pública com a sub-rede pública
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Associação da tabela de rotas privada com a sub-rede privada
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Grupo de segurança para EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grupo-seguranca-ec2"
  }
}

# Criação da chave SSH
resource "aws_key_pair" "generated_key" {
  key_name   = "terabite-${uuid()}"
  public_key = file("terabite.pem.pub")
}


output "key_name" {
  value = aws_key_pair.generated_key.key_name
}

output "main_vpc" {
  value = aws_vpc.main.cidr_block
}

output "vpc_cidr" {  
  value = var.vpc_cidr  
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "public_rt" {
  value = aws_route_table.public_rt.id
}

output "private_rt" {
  value = aws_route_table.private_rt.id
}

