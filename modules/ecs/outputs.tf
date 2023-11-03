output "private_subnets" {
    value = values(aws_subnet.private)[*].id
}

output "public_subnets" {
    value = values(aws_subnet.public)[*].id
}

output "ecs_cluster_arn" {
    value = aws_ecs_cluster.ecs_cluster.id
}

output "vpc_id"  {
    value = aws_vpc.main.id
}