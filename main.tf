resource "aws_vpc" "vpc_01" {
  cidr_block       = var.vpc1_cidr
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc_01.id
}

resource "aws_subnet" "subnet_01" {
  vpc_id                  = aws_vpc.vpc_01.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet_01_cidr
}

resource "aws_ec2_transit_gateway" "tgw_01" {
  description     = "transit gateway-01"
  amazon_side_asn = var.asn
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_01" {
  subnet_ids         = [aws_subnet.subnet_01.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_01.id
  vpc_id             = aws_vpc.vpc_01.id
}

resource "aws_route_table" "rt_01" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_01.id
  }

  route {
    cidr_block         = "10.2.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_01.id
  }

  tags = {
    Name = "route-01"
  }
}

resource "aws_route_table_association" "st_sn_01" {
  subnet_id      = aws_subnet.subnet_01.id
  route_table_id = aws_route_table.rt_01.id
}

resource "aws_security_group" "my_sg_01" {
  vpc_id = aws_vpc.vpc_01.id
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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec1" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.my_sg_01.id
  ]
  subnet_id = aws_subnet.subnet_01.id
}

resource "aws_vpc" "vpc_02" {
  cidr_block       = var.vpc2_cidr
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "igw_02" {
  vpc_id = aws_vpc.vpc_02.id
}

resource "aws_subnet" "subnet_02" {
  vpc_id                  = aws_vpc.vpc_02.id
  map_public_ip_on_launch = true
  cidr_block              = var.subnet_02_cidr
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_02" {
  subnet_ids         = [aws_subnet.subnet_02.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw_01.id
  vpc_id             = aws_vpc.vpc_02.id
}

resource "aws_route_table" "rt_02" {
  vpc_id = aws_vpc.vpc_02.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_02.id
  }

  route {
    cidr_block         = "10.1.1.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw_01.id
  }

  tags = {
    Name = "route-02"
  }
}

resource "aws_route_table_association" "st_sn_02" {
  subnet_id      = aws_subnet.subnet_02.id
  route_table_id = aws_route_table.rt_02.id
}

resource "aws_security_group" "my_sg_02" {
  vpc_id = aws_vpc.vpc_02.id
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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  vpc_security_group_ids = [
    aws_security_group.my_sg_02.id
  ]
  subnet_id = aws_subnet.subnet_02.id
}