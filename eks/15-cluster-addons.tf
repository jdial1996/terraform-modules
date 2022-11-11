# EBS CSI DRIVER

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks-cluster.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.11.4-eksbuild.1" 
  service_account_role_arn = aws_iam_role.ebs_csi.arn

}