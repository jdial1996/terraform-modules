# Create VPC - virtual data center for our kubernetes cluster 

# 
# EKS requires:

# 1. VPC supports DNS : enable dns_support and dns_hostname 
# 


resource "aws_vpc" "main" {

  # cidr block for VPC
  cidr_block = "192.168.0.0/16"

  # Make your instances shared on the host using value of default 
  instance_tenancy = "default"

  # enable/disable dns support in vpc - EKS requirement
  enable_dns_support = true

  # enable/disable dns hostnames in vpc - EKS requirement
  enable_dns_hostnames = true

  enable_classiclink_dns_support = false

  tags = {
    Name = "main"
  }

}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id"
  sensitive   = false
}