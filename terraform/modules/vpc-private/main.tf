# Define VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name       = "${var.project}_${var.environment}"
    Environment = var.environment
  }
}

# Get the availability zones list
data "aws_availability_zones" "available" {
}

# Define the public subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name       = "${var.project}_${var.environment}_public_subnet_a"
    Type       = "${var.project}Public"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name       = "${var.project}_${var.environment}_public_subnet_b"
    Type       = "Public"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_c_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name       = "${var.project}_${var.environment}_public_subnet_c"
    Type       = "Public"
    Environment = var.environment
  }
}

# Define the private subnet
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name       = "${var.project}_${var.environment}_private_subnet_a"
    Type       = "Private"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name       = "${var.project}_${var.environment}_private_subnet_b"
    Type       = "Private"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name       = "${var.project}_${var.environment}_private_subnet_c"
    Type       = "Private"
    Environment = var.environment
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "${var.project}_${var.environment}_igw"
    Type       = "Public"
    Environment = var.environment
  }
}

# Define Elastic IP for NAT Gateway
resource "aws_eip" "nat_gw_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

# Define NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet_b.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name       = "${var.project}_${var.environment}_nat"
    Type       = "Public"
    Environment = var.environment
  }
}

# Define the public route table
resource "aws_route_table" "vpc_public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "${var.project}_${var.environment}_public_subnet_route_table"
    Environment = var.environment
  }
}

resource "aws_route" "public_rt_internet_gw" {
  route_table_id         = aws_route_table.vpc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Define the private route table
resource "aws_route_table" "vpc_private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "${var.project}_${var.environment}_private_subnet_route_table"
    Environment = var.environment
  }
}

resource "aws_route" "private_rt_nat_gw" {
  route_table_id         = aws_route_table.vpc_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Assign the route table to the public Subnets
resource "aws_route_table_association" "web_public_rt_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.vpc_public_rt.id
}

resource "aws_route_table_association" "web_public_rt_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.vpc_public_rt.id
}

resource "aws_route_table_association" "web_public_rt_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.vpc_public_rt.id
}

# Assign the route table to the private Subnets
resource "aws_route_table_association" "web_private_rt_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.vpc_private_rt.id
}

resource "aws_route_table_association" "web_private_rt_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.vpc_private_rt.id
}

resource "aws_route_table_association" "web_private_rt_c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.vpc_private_rt.id
}
