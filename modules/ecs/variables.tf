variable "cluster_name" {
    type = string 
    default = "my-cluster"
}

variable "environment" {
    type = string 
    default = "test"
}

variable "private_subnet_numbers" {
    default = {
        4 = "eu-west-1a"
        5 = "eu-west-1b"
        6 = "eu-west-1c"
    } 
}

variable "public_subnet_numbers" {
    default = {
        1 = "eu-west-1a"
        2 = "eu-west-1b"
        3 = "eu-west-1c"
    } 
}

variable "vpc_cidr" {
    description = "The CIDR block you want to assign to the new VPC"
    default = "10.0.0.0/16"
    type = string
}

variable "ecs_task_exeuction_role" {
    description = "The IAM role ARN that allows ECS nodes and the docker daemon to make AWS API calls."
    default = "arn:aws:iam::355285117207:role/test-role"
    type = string 
}