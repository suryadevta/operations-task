# Define VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name       = "${var.name_prefix}-${var.environment}"
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
  map_public_ip_on_launch = true
  tags = {
    Name       = "${var.name_prefix}_${var.environment}_public_subnet_a"
    Type       = "Public"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name       = "${var.name_prefix}_${var.environment}_public_subnet_b"
    Type       = "Public"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_c_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
  tags = {
    Name       = "${var.name_prefix}_${var.environment}_public_subnet_c"
    Type       = "Public"
    Environment = var.environment
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "${var.name_prefix}_${var.environment}_igw"
    Type       = "Public"
    Environment = var.environment
  }
}

# Define the public route table
resource "aws_route_table" "vpc_public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "${var.name_prefix}_${var.environment}_public_subnet_route_table"
    Environment = var.environment
  }
}

resource "aws_route" "public_rt_internet_gw" {
  route_table_id         = aws_route_table.vpc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
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