# NAT gateway is used in private subnets to allow services to connect to the internet 
# NAT gateway must be placed in public subnet. The subnet must have a route to the internet gateway
# NAT Gateway needs a fixed ip (elastic ip)

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-eu-west-1a.id

  tags = {
    name = "nat"
  }

  depends_on = [aws_internet_gateway.main_igw]
}