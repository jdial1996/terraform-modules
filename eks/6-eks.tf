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
    role = aws_iam_role.eks-cluster-role.name
}
# bare minimum eks cluster 

resource "aws_eks_cluster" "eks-cluster" {
    role_arn = aws_iam_role.eks-cluster-role.arn
    name = var.eks_cluster_name
    version = var.eks_cluster_version
    enabled_cluster_log_types = ["audit"]
    #  subnets in which nodes and load balancers will be created
    vpc_config {
        subnet_ids = [
            aws_subnet.private-eu-west-2a.id,
            aws_subnet.private-eu-west-2b.id,
            aws_subnet.private-eu-west-2c.id,
            aws_subnet.public-eu-west-2a.id,
            aws_subnet.public-eu-west-2b.id,
            aws_subnet.public-eu-west-2c.id,

        ]
    }

    depends_on = [aws_iam_role_policy_attachment.eks-cluster-policy]

}


resource "kubernetes_config_map" "aws-auth" {
  data = {
    "mapRoles" = <<-EOT
                - groups:
                  - system:bootstrappers
                  - system:nodes
                  rolearn: arn:aws:iam::421716472970:role/eks-node-group-role
                  username: system:node:{{EC2PrivateDNSName}}
            EOT
    "mapUsers" = <<-EOT
                - userarn:  arn:aws:iam::421716472970:user/gha-role
                  username: rbac-user
                  groups:
                  - system:masters
            EOT
  }

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}
