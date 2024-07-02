resource "aws_vpc" "default" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.name
    }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
  
  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  for_each = var.subnets
  subnet_id      = aws_subnet.default[each.key].id
  route_table_id = aws_route_table.default.id
}

resource "aws_subnet" "default" {
    for_each = var.subnets
    vpc_id = aws_vpc.default.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = each.value.map_public_ip_on_launch
    tags = {
        Name = each.value.name
    }
}