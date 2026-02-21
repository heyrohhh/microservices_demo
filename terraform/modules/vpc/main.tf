# creating vpc 

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "main"
  }
}

data "aws_availability_zones" "zone" {
  state = "available"
}

resource "aws_subnet" "public_subnet1"{
      vpc_id = aws_vpc.main.id
      cidr_block = "10.0.1.0/24"
      map_public_ip_on_launch = true
      availability_zone = data.aws_availability_zones.zone.names[0]

      tags ={
            Name = "public_subnet1"
      }
}

resource "aws_subnet" "public_subnet1a"{
      vpc_id = aws_vpc.main.id
      cidr_block = "10.0.2.0/24"
      map_public_ip_on_launch = true
      availability_zone = data.aws_availability_zones.zone.names[1]

      tags ={
            Name = "public_subnet1a"
      }
}

resource "aws_subnet" "private_subnet1"{
      vpc_id = aws_vpc.main.id
      cidr_block = "10.0.3.0/24"
      map_public_ip_on_launch = false
      availability_zone = data.aws_availability_zones.zone.names[0]

      tags ={
            Name = "private_subnet1"
      }
}

resource "aws_subnet" "private_subnet1a"{
      vpc_id = aws_vpc.main.id
      cidr_block = "10.0.4.0/24"
      map_public_ip_on_launch = false
      availability_zone = data.aws_availability_zones.zone.names[1]

      tags ={
            Name = "private_subnet1a"
      }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rt" {
      vpc_id = aws_vpc.main.id

      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
      }

      tags = {
         Name = "public_rt"
      }
}


resource "aws_route_table_association" "rt_assoc1" {
        subnet_id = aws_subnet.public_subnet1.id
        route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_assoc2" {
        subnet_id = aws_subnet.public_subnet1a.id
        route_table_id = aws_route_table.public_rt.id
}

#nat gateway

resource "aws_eip" "eip"{
     domain = "vpc"

     tags = {
        Name = "eip"
     }
}

resource "aws_nat_gateway" "nat" {
     allocation_id  = aws_eip.eip.id
      subnet_id = aws_subnet.public_subnet1.id

      tags = {
        Name = "nat-gateway"
      }
}

resource "aws_route_table" "private_rt"{
      vpc_id = aws_vpc.main.id
      
      route {
           cidr_block = "0.0.0.0/0"
           nat_gateway_id = aws_nat_gateway.nat.id
      }

      tags={
        Name = "private_rt"
      }
}

resource "aws_route_table_association" "pvt_rt_assoc1" {
           subnet_id = aws_subnet.private_subnet1.id
           route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "pvt_rt_assoc1a" {
           subnet_id = aws_subnet.private_subnet1a.id
           route_table_id = aws_route_table.private_rt.id
}
