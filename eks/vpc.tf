data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"
  name    = "my-vpc"
  cidr    = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = var.enable_ha_nat_gateway # enable k8s worklaods in private subnets to communicate with internet
  single_nat_gateway   = var.single_nat_gateway # will only create a nat gateway in a single AZ 
  enable_dns_hostnames = true # means that worker nodes will have hostnames assigned to them (public oens only? )
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

