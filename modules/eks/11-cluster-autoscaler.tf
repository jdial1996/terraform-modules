resource "helm_release" "metrics-server" {
  count = var.cluster_autoscaler_enabled ? 1 : 0
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.8.2"


  set {
      name = "hostNetwork.enabled"
      value = true 
  }

}