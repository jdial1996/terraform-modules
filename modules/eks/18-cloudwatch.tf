resource "helm_release" "cloudwatch_agent" {
  count = var.cloudwatch_agent ? 1 : 0
  name       = "cloudwatch-agent"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-cloudwatch-metrics"
  version    = var.cloudwatch_agent_version

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
}