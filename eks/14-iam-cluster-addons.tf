data "aws_iam_policy_document" "ebs_csi_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"] #replace audience with Kubernetes service account (create aws-test sa in default namesapce)
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "ebs_csi" {
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy.json
  name               = "ebs-csi-driver"
}

resource "aws_iam_policy" "ebs_csi" {
  name = "ebs-csi-driver"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  policy_arn = aws_iam_policy.ebs_csi.arn
  role       = aws_iam_role.ebs_csi.name
}

output "ebs_csi_role_arn" {
  value = aws_iam_role.ebs_csi.arn

}