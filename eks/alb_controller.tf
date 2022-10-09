locals {
  service_account_namespace = "kube-system"
  service_account_name      = "aws-load-balancer-controller"

}


resource "helm_release" "alb-controller" {
  count = var.alb-controller ? 1 : 0
  name       = "alb-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.5"
  namespace = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "replicaCount"
    value = 1
  }
}

# IAM policy to enable AWS LB Controller to make api calls to aws services
resource "aws_iam_policy" "aws_lb_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("policies/iam/alb-policy.json")
}

# Creates single IAM role which can be assumed by trusted resources using OpenID Connect Federated Users.
module "iam_assumable_role_with_oidc" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4"
  create_role                   = true
  role_name                     = "aws-load-balancer-controller"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [aws_iam_policy.aws_lb_controller.arn]
  number_of_role_policy_arns    = 1
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.service_account_namespace}:${local.service_account_name}"]
}