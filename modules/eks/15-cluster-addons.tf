# EBS CSI DRIVER

resource "aws_eks_addon" "ebs_csi_driver" {
  count = var.ebs_csi_enabled ? 1 : 0
  cluster_name             = aws_eks_cluster.eks-cluster.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_version
  service_account_role_arn = aws_iam_role.ebs_csi.arn

}