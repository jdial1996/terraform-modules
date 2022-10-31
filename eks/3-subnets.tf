# Create subnets to deploy EKS worker nodes into.  The setup is HA. 
# kubrrnetes.io/cluster/demo = 1 tag is there for k8s to discover subnets where private loadbalancers are created
# kubernetes/io/cluster/<cluster-name> = owned | shared

resource "aws_subnet" "private-eu-west-2a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/25"
    availability_zone = "eu-west-2a"

    tags = {
        "Name" = "private-eu-west-2a"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "private-eu-west-2b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.128/25"
    availability_zone = "eu-west-2b"

    tags = {
        "Name" = "private-eu-west-2b"
        "kubernetes.io/role/internal-elb" = "1"  
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "private-eu-west-2c" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/25"
    availability_zone = "eu-west-2c"


    tags = {
        "Name" = "private-eu-west-2c"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public-eu-west-2a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.128/25"
    availability_zone = "eu-west-2a"
    map_public_ip_on_launch = true   # only set to true if you need to create public nodes.  Each publuc worker node will get an ip attached to it


    tags = {
        "Name" = "public-eu-west-2a"
        "kubernetes.io/cluster/role/elb" = "1"  # instructs k8s to create public loadbalancers in these subnets
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public-eu-west-2b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/25"
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = true 


    tags = {
        "Name" = "public-eu-west-2b"
        "kubernetes.io/cluster/role/elb" = "1"
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public-eu-west-2c" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.128/25"
    availability_zone = "eu-west-2c"
    map_public_ip_on_launch = true 

 
    tags = {
        "Name" = "public-eu-west-2c"
        "kubernetes.io/cluster/role/elb" = "1"
        "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
}