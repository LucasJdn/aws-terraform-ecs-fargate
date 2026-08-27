terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#----------------------------------------
# VPC's
#----------------------------------------
resource "aws_vpc" "Project" {
  cidr_block = "10.2.0.0/16"

  tags = {
    Name = "Project-VPC"
  }
}

#----------------------------------------
# Subnets
#----------------------------------------
resource "aws_subnet" "Public01" {
    vpc_id = aws_vpc.Project.id
    cidr_block = "10.2.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = "PublicSubnet01"
    }
}

resource "aws_subnet" "Private01" {
    vpc_id = aws_vpc.Project.id
    cidr_block = "10.2.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "PrivateSubnet01"
    }
}

resource "aws_subnet" "Public02" {
    vpc_id = aws_vpc.Project.id
    cidr_block = "10.2.3.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
      Name = "PublicSubnet02"
    }
}

resource "aws_subnet" "Private02" {
    vpc_id = aws_vpc.Project.id
    cidr_block = "10.2.4.0/24"
    availability_zone = "us-east-1b"

    tags = {
      Name = "PrivateSubnet02"
    }
}

#----------------------------------------
# Internet Gateway
#----------------------------------------
resource "aws_internet_gateway" "InternetGateway"{
    vpc_id = aws_vpc.Project.id

    tags = {
      Name = "InternetGateway"
    }
}

#----------------------------------------
# NAT Gateway
#----------------------------------------
resource "aws_nat_gateway" "NatGateway01"{
    subnet_id = aws_subnet.Public01.id
    allocation_id = aws_eip.NAT01.id

    tags = {
      Name = "NatGateway01"
    }
}

resource "aws_eip" "NAT01"{
  domain = "vpc"

  tags = {
    Name = "EIP-NAT01"
  }
}

resource "aws_nat_gateway" "NatGateway02"{
    subnet_id = aws_subnet.Public02.id
    allocation_id = aws_eip.NAT02.id

    tags = {
      Name = "NatGateway02"
    }
}

resource "aws_eip" "NAT02"{
  domain = "vpc"

  tags = {
    Name = "EIP-NAT02"
  }
}

#----------------------------------------
# Route Table
#----------------------------------------

#   Public
resource "aws_route_table" "RT-Public"{
    vpc_id = aws_vpc.Project.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.InternetGateway.id
    }

    tags = {
      Name = "RouteTable Public"
    }
}

resource "aws_route_table_association" "IG_RT1"{
    route_table_id = aws_route_table.RT-Public.id
    subnet_id = aws_subnet.Public01.id
}
resource "aws_route_table_association" "IG_RT2"{
    route_table_id = aws_route_table.RT-Public.id
    subnet_id = aws_subnet.Public02.id
}


#   Private1
resource "aws_route_table" "RT-Private01"{
    vpc_id = aws_vpc.Project.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NatGateway01.id
    }

    tags = {
      Name = "RouteTable Private 01"
    }
}
resource "aws_route_table_association" "NAT_RT01"{
    route_table_id = aws_route_table.RT-Private01.id
    subnet_id = aws_subnet.Private01.id
}

#   Private2
resource "aws_route_table" "RT-Private02"{
    vpc_id = aws_vpc.Project.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NatGateway02.id
    }

    tags = {
      Name = "RouteTable Private 02"
    }
}
resource "aws_route_table_association" "NAT_RT02"{
    route_table_id = aws_route_table.RT-Private02.id
    subnet_id = aws_subnet.Private02.id
}