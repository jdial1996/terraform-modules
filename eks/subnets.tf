# Create public and private subnets with appropriate subnet tags that eks managed k8s cluster can disocver and
# create public and private loadbalancers. 
# Create a set of public and private subnets across in 2 AZ's

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.0.0/18"
  availability_zone = "eu-west-2a"

  # An EKS requirement.  Every new instance that gets launched into the subnet should be assigned 
  #  a public IP  
  map_public_ip_on_launch = true

  tags = {
    Name                        = "public-eu-west-2a" # name not important - can name however you want
    "kubernetes.io/cluster/eks" = "shared"            # means we will allow the eks cluster to discover this subnet and use it
    "kubernetes.io/role/elb"    = 1                   # mandatory to deploy public loadbalancers  ( when you use a service type of loadbalancer),, it will placel oadbalancers in this subnet 
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.64.0/18"
  availability_zone = "eu-west-2b"

  # An EKS requirement.  Every new instance that gets launched into the subnet should be assigned 
  #  a public IP  
  map_public_ip_on_launch = true

  tags = {
    Name                        = "privat-eu-west-2b" # name not important - can name however you want
    "kubernetes.io/cluster/eks" = "shared"            # means we will allow the eks cluster to discover this subnet and use it
    "kubernetes.io/role/elb"    = 1                   # mandatory to deploy public loadbalancers  ( when you use a service type of loadbalancer),, it will placel oadbalancers in this subnet 
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = "eu-west-2a"

  tags = {
    Name                        = "private-eu-west-2b" # name not important - can name however you want
    "kubernetes.io/cluster/eks" = "shared"             # means we will allow the eks cluster to discover this subnet and use it
    "kubernetes.io/role/elb"    = 1                    # mandatory to deploy private loadbalancers  ( when you use a service type of loadbalancer),, it will placel oadbalancers in this subnet 
  }
}


resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = "eu-west-2b"

  tags = {
    Name                        = "private-eu-west-2b" # name not important - can name however you want
    "kubernetes.io/cluster/eks" = "shared"             # means we will allow the eks cluster to discover this subnet and use it
    "kubernetes.io/role/elb"    = 1                    # mandatory to deploy private loadbalancers  ( when you use a service type of loadbalancer),, it will placel oadbalancers in this subnet 
  }
}