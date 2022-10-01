# terraform version 

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.7.0"
    }
  }
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-2"
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

