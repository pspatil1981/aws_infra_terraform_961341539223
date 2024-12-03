
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.key
  availability_zone = element(var.availability_zones, index(var.public_subnets, each.key))
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${each.key}"
  }
}


resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.key
  availability_zone = element(var.availability_zones, index(var.private_subnets, each.key))

  tags = {
    Name = "private-subnet-${each.key}"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

