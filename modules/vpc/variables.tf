variable "vpc_cidr" {
    description = "The CIDR block you want to assign to the new VPC"
    default = "10.0.0.0/16"
    type = string
}

variable "environment" {
    description = "The environment to deploy the VPC in"
    type = string 
    validation {
        condition     = contains(["staging", "production"], var.environment)
        error_message = "Must be either \"staging\" or \"production\"."
    }
}

variable "public_subnet_numbers" {
    default = {
        1 = "eu-west-1a"
        2 = "eu-west-1b"
        3 = "eu-west-1c"
    } 
}

variable "private_subnet_numbers" {
    default = {
        4 = "eu-west-1a"
        5 = "eu-west-1b"
        6 = "eu-west-1c"
    } 
}

variable "public_subnet_tags" {
    type = map
    description = "Additional tags for public subnets"
    default = {Environment = "staging"}
}

variable "private_subnet_tags" {
    default = {Environment = "production"}
    type = map
    description = "Additional tags for private subnets"
}