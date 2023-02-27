# EKS will need to make api calls to other services on your behalf.  For example, for the cluster autoscaler too add/remove instances depending on load
# Therefore before we create the EKS cluster, we need to create an IAM role with an EKS cluster policy 

resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }

    ]
  })
}

# Attach the required IAM policy to the above IAM Role

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}
# bare minimum eks cluster 

resource "aws_eks_cluster" "eks-cluster" {
  role_arn                  = aws_iam_role.eks-cluster-role.arn
  name                      = var.eks_cluster_name
  version                   = var.eks_cluster_version
  enabled_cluster_log_types = var.cluster_log_types
  #  subnets in which nodes and load balancers will be created
  vpc_config {
    subnet_ids = [
      aws_subnet.private-eu-west-1a.id,
      aws_subnet.private-eu-west-1b.id,
      aws_subnet.private-eu-west-1c.id,
      aws_subnet.public-eu-west-1a.id,
      aws_subnet.public-eu-west-1b.id,
      aws_subnet.public-eu-west-1c.id,

    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks-cluster-policy]

}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks-cluster.arn
}
