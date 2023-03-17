# resource "helm_release" "kube_state" {
# #   count = var.cloudwatch_agent ? 1 : 0
#   name       = "kube-state-metrics"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-state-metrics"
#   version = 5.00
# }
#   set {
#     name  = "clusterName"
#     value = var.eks_cluster_name
#   }

# Creates: kube-state-metrics, node exporter and operator
resource "helm_release" "kube_prometheus_stack" {
  count = var.prometheus_enabled ? 1 : 0
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [
    "${file("values/prometheus-values.yaml")}"
  ]

  depends_on = [aws_eks_cluster.eks-cluster]
}
#   version = 5.00

#   set {
#     name  = "clusterName"
#     value = var.eks_cluster_name
#   }