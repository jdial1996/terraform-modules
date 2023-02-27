terraform {
  required_providers {
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.17.1"
    }
  }
  required_version = ">= 0.12.0"
}





provider "aws" {
  version = ">= 2.28.1"
  region  = "eu-west-1"
}



provider "postgresql" {
  host            = "terraform-20220922171412735400000001.cgzfkgfswxis.eu-west-1.rds.amazonaws.com"
  port            = 5432
  database        = "postgres"
  username        = "postgres"
  password        = "pulumiproblems"
  sslmode         = "require"
  connect_timeout = 15
}