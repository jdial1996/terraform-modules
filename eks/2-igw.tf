# To provide internet access to our Kubernetes cluster, attach an IGW to your VPC

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}