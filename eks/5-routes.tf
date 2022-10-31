# Create a private route table with a default route to the nat gateway 

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

# Create a public route table with a default route to the internet gateway 

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "public"
  }
}

# To associate subnets with route tables we need to create subnet associations

resource "aws_route_table_association" "private-eu-west-2a" {
  subnet_id      = aws_subnet.private-eu-west-2a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-2b" {
  subnet_id      = aws_subnet.private-eu-west-2b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-2c" {
  subnet_id      = aws_subnet.private-eu-west-2c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-west-2a" {
  subnet_id      = aws_subnet.public-eu-west-2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-2b" {
  subnet_id      = aws_subnet.public-eu-west-2b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-2c" {
  subnet_id      = aws_subnet.public-eu-west-2c.id
  route_table_id = aws_route_table.public.id
}