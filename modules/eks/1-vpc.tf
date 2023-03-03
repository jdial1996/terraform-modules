module "vpc" {
  source =  "git::git@github.com:jdial1996/terraform.git//modules/vpc?ref=v0.3.0"
  environment = "staging"
  public_subnet_tags = {
    "kubernetes.io/role/elb"                        = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

output "vpc" {

  value = module.vpc
}