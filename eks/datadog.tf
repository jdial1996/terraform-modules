
# This helm chart will install the datadog agent daemonset into your cluster
# so that Datadog is able to push application events, logs and metrics to datadoghq.

# You will also have to install the Kubernetes datadog integration in the datadog console to be able to 
# view kubernetes related data in Datadog

# resource "helm_release" "datadog" {
#   count = var.datadog ? 1 : 0
#   name       = "datadog"
#   repository = "https://helm.datadoghq.com"
#   chart      = "datadog"
#   version    = "3.1.3"

#   values = [
#     "${file("values/datadog-values.yaml")}"
#   ]

#   set {
#     name  = "datadog.apiKey"
#     value = var.dd_api_key
#   }
# }