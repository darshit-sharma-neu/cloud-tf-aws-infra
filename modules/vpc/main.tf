# VPC
resource "aws_vpc" "csye6225_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "csye6225_vpc"
  }
}

# Public Subnets 
resource "aws_subnet" "public_subnets"{
  count = length(var.public_subnets_cidrs)
  vpc_id = aws_vpc.csye6225_vpc.id
  cidr_block = element(var.public_subnets_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)  

  tags = {
    Name = "csye6225_public_subnet_${count.index}"
  }
}

#Private Subnets
resource "aws_subnet" "private_subnets"{
  count = length(var.private_subnets_cidrs)
  vpc_id = aws_vpc.csye6225_vpc.id
  cidr_block = element(var.private_subnets_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)  

  tags = {
    Name = "csye6225_public_subnet_${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "csye6225_igw" {
  vpc_id = aws_vpc.csye6225_vpc.id

  tags = {
    Name = "csye6225_igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.csye6225_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.csye6225_igw.id  
  }

  tags = {
    Name = "csye6225_public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id 
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.csye6225_vpc.id

  tags = {
    Name = "csye6225_private_route_table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id 
}