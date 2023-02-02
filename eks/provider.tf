# terraform version 

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.7.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
}

provider "datadog" {
  api_key = "aa07fbdc96b178ca6d61efc3eaa4ce06"
  app_key = "49d150fb892557a952081d530a2af623558943ca"
  api_url =  "https://api.datadoghq.eu/"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}



provider "kubernetes" {
  # Configuration options
  config_path    = "~/.kube/config"
}

