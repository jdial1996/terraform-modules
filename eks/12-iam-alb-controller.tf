data "aws_iam_policy_document" "aws_alb_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"] #replace audience with Kubernetes service account (create aws-test sa in default namesapce)
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_alb" {
  assume_role_policy = data.aws_iam_policy_document.aws_alb_assume_role_policy.json
  name               = "alb-controller"
}

resource "aws_iam_policy" "aws_alb" {
  name   = "cluster_autoscaler"
  policy = file("alb_iam_policy.json")

}

resource "aws_iam_role_policy_attachment" "aws_alb" {
  policy_arn = aws_iam_policy.aws_alb.arn
  role       = aws_iam_role.aws_alb.name
}

output "aws_alb_role_arn" {
  value = aws_iam_role.aws_alb.arn
}