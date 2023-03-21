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