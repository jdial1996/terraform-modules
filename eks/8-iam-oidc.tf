# Get certificate for EKS

data  "tls_certificate" "eks" {
    url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

# Create Provider 

# Test the provider before using it to provide permissions to any services
resource "aws_iam_openid_connect_provider" "eks" {
    client_id_list = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
    url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

output "eks_cluster" {
    value = aws_eks_cluster.eks-cluster
}