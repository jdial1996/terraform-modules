
variable "eks_cluster_name" {
  type    = string
  default = "playground-cluster"
}

variable "eks_cluster_version" {
  description = "The version of the Kubernetes Cluster"
  default     = "1.21"
  type        = string
}

variable "private_subnet_cidrs" {
    type = list(string)
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] 
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_ha_nat_gateway" {
    type = bool
    default = true
}

variable "single_nat_gateway" {
  type = bool 
  default = true 
}

variable "enable_irsa" {
  type = bool 
  default = true 
}

variable "node_group" {
  type = map 
  default = {
    "min" = 1
    "desired" = 1
    "max" = 2
    "instance_type" = "t2.small"
    "capacity_type"   = "ON_DEMAND"
  }

}

variable "dd_api_key" {
  default = ""
}

variable "datadog" {
  default = false
  
}

variable "alb-controller" {
  default = true

}