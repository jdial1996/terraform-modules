resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "${var.environment}-vpc}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  for_each          = var.public_subnet_numbers
  availability_zone = each.value
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, each.key)
  tags = {
    type = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.private_subnet_numbers
  availability_zone = each.value
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, each.key)
  tags = {
    type = "private"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    name = "nat"
  }
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = values(aws_subnet.public).*.id[0]
  allocation_id = aws_eip.nat_eip.id
  tags = {
    Environment = var.environment
  }

  depends_on = [
    aws_internet_gateway.gw,
    aws_eip.nat_eip
  ]
}

# # Create a private route table with a default route to the nat gateway 

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name        = "private"
    Environment = var.environment
  }
}

# # Create a public route table with a default route to the internet gateway 

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "public"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id

}