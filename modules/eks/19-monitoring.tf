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

resource "helm_release" "metrics_server" {
  count = var.metrics_server_enabled ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version = var.metrics_server_version

  depends_on = [aws_eks_cluster.eks-cluster]
}