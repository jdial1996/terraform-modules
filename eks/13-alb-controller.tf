# # Need to enable inbound TCP traffic on nodegroup security group from eks cluster (control plane ) security group on port 9443, otherwise aws alb controller will not be able to communciate with k8s api server 

resource "kubernetes_service_account" "aws_albic_sa" {
  depends_on = [
    aws_eks_cluster.eks-cluster,
  ]
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" : "arn:aws:iam::421716472970:role/alb-controller"
    }

  }
}


resource "helm_release" "alb-controller" {
  count      = var.alb-controller ? 1 : 0
  name       = "alb-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.4.5"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "replicaCount"
    value = 1
  }

  depends_on = [
    kubernetes_service_account.aws_albic_sa,
  ]
}