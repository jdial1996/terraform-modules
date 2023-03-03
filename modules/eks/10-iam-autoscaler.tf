# # test iam policy 

# data "aws_iam_policy_document" "cluster_autoscaler_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:cluster-autoscaler"] #replace audience with Kubernetes service account (create aws-test sa in default namesapce)
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "cluster_autoscaler" {
#   assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role_policy.json
#   name               = "cluster-autoscaler"
# }

# resource "aws_iam_policy" "cluster_autoscaler" {
#   name = "cluster-autoscaler"
#   policy = jsonencode({
#     Statement = [{
#       Action = [
#         "autoscaling:DescribeAutoScalingInstances",
#         "autoscaling:DescribeAutoScalingGroups",
#         "ec2:DescribeLaunchTemplateVersions",
#         "autoscaling:DescribeTags",
#         "autoscaling:DescribeLaunchConfigurations",
#         "autoscaling:SetDesiredCapacity",
#         "autoscaling:TerminateInstanceInAutoScalingGroup"
#       ],
#       Effect   = "Allow"
#       Resource = "*"
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
#   policy_arn = aws_iam_policy.cluster_autoscaler.arn
#   role       = aws_iam_role.cluster_autoscaler.name
# }

# output "cluster_autoscaler_role_arn" {
#   value = aws_iam_role.cluster_autoscaler.arn

# }