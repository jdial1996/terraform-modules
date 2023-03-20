provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
}

terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    local = {
      source = "hashicorp/local"
      version = "2.3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
    }
  }
}


provider "cloudflare" {
    api_token="1LlUl24DDMNQHltpzY2jUAXXtbFq4lQevHT2QXMb"
}


provider "tls" {
}

provider "local" {
}