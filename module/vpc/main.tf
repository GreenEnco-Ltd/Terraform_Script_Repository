resource "aws_vpc" "vpc" {
    cidr_block       = var.vpc_id
    instance_tenancy = var.instance_tenancy
    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
        Name = "GreenEnco_VPC_New"
    }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id  # Replace with your VPC ID
  cidr_block        = var.public_subnet_id_value   # Replace with your desired CIDR block
  availability_zone = var.availability_zone # Replace with your desired Availability Zone
   map_public_ip_on_launch = true           # Enable auto-assign public IP

  # Optional: Assign tags to your subnets
  tags = {
    Name = "GreenEnco_Public_Subnet_New"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id  # Replace with your VPC ID
  cidr_block        = var.private_subnet_id_value  # Replace with your desired CIDR block
  availability_zone = var.availability_zone1 # Replace with your desired Availability Zone

  # Optional: Assign tags to your subnets
  tags = {
    Name = "GreenEnco_Private_Subnet_New"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  # Optional: Assign tags to your Internet Gateway
  tags = {
    Name = "GreenEnco_Internet_Gateway_New"
  }
}

resource "aws_eip" "eip" {
    vpc  = true

  # Optional: Associate tags with the Elastic IP
  tags = {
    Name = "GreenEnco_ElasticIP_New"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

# Optional: Associate tags with the Elastic IP
  tags = {
    Name = "GreenEnco_net-gateway_New"
  }
}

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "GreenEnco_RouteTable_Public_New"
  }
}

resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  # Optional: Assign tags to your route table
  tags = {
    Name = "GreenEnco_RouteTable_Private_New"
  }
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.Private_RT.id
}