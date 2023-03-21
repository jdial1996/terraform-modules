
variable "eks_cluster_name" {
  type    = string
  default = "playground-cluster"
}

variable "cluster_log_types" {
  type = list(string)
  default = ["audit"]
}

variable "eks_cluster_version" {
  description = "The version of the Kubernetes Cluster"
  default     = "1.22"
  type        = string
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/25", "10.0.0.128/25", "10.0.1.0/25"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.128/25", "10.0.2.0/25", "10.0.2.128/25"]
}

variable "enable_ha_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_irsa" {
  type    = bool
  default = true
}

variable "max_nodes" {
  default = 5
}

variable "min_nodes" {
  default = 0 
}

variable "desired_nodes" {
  default = 1
}
variable "node_group" {
  type = map(any)
  default = {
    "min"           = 0
    "desired"       = 1
    "max"           = 5
    "instance_type" = "t2.small"
    "capacity_type" = "ON_DEMAND"
  }

}

variable "dd_api_key" {
  default = ""
}

variable "datadog" {
  default = false

}

variable "cloudwatch_agent" {
  default = false

}

variable "prometheus_enabled" {
  default = true
}

variable "metrics_server_enabled" {
  default = true
}

variable "metrics_server_version" {
  default = "3.8.4"
}

variable "alb_controller_enabled" {
  default = true
}

variable "cert_manager_enabled" {
  default = false
}

variable "cluster_autoscaler_enabled" {
  default = true
}

variable "ebs_csi_enabled" {
  default = false
}

variable "ebs_csi_version" {
  default = "v1.11.4-eksbuild.1"
}

variable "cloudwatch_agent_version" {
  default = "0.0.8"
}


################

variable "vpc_cidr_range" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "main"
}