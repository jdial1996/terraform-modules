resource "helm_release" "cert-manager" {
  count = var.cert_manager_enabled ? 1 : 0
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.9.1"


  set {
    name  = "installCRDs"
    value = true
  }
}