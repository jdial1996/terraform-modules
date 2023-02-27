# Create subnets to deploy EKS worker nodes into.  The setup is HA. 
# kubrrnetes.io/cluster/demo = 1 tag is there for k8s to discover subnets where private loadbalancers are created
# kubernetes/io/cluster/<cluster-name> = owned | shared

resource "aws_subnet" "private-eu-west-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, 0)
  availability_zone = element(data.aws_availability_zones.available.names, 0)

  tags = {
    "Name"                                          = "private-${element(data.aws_availability_zones.available.names, 0)}"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-eu-west-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, 1)
  availability_zone = element(data.aws_availability_zones.available.names, 1)

  tags = {
    "Name"                                          = "private-${element(data.aws_availability_zones.available.names, 1)}"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-eu-west-1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, 2)
  availability_zone = element(data.aws_availability_zones.available.names, 2)


  tags = {
    "Name"                                          = "private-${element(data.aws_availability_zones.available.names, 2)}"
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, 0)
  availability_zone       = element(data.aws_availability_zones.available.names, 0)
  map_public_ip_on_launch = true # only set to true if you need to create public nodes.  Each publuc worker node will get an ip attached to it


  tags = {
    "Name"                                          = "public-${element(data.aws_availability_zones.available.names, 0)}"
    "kubernetes.io/role/elb"                        = "1" # instructs k8s to create public loadbalancers in these subnets
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, 1)
  availability_zone       = element(data.aws_availability_zones.available.names, 1)
  map_public_ip_on_launch = true


  tags = {
    "Name"                                          = "public-${element(data.aws_availability_zones.available.names, 1)}"
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, 2)
  availability_zone       = element(data.aws_availability_zones.available.names, 2)
  map_public_ip_on_launch = true


  tags = {
    "Name"                                          = "public-${element(data.aws_availability_zones.available.names, 2)}"
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
