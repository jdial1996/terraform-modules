# # test iam policy 

# data "aws_iam_policy_document" "test_oidc_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:default:aws-test"] #replace audience with Kubernetes service account (create aws-test sa in default namesapce)
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.eks.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "test_oidc" {
#   assume_role_policy = data.aws_iam_policy_document.test_oidc_assume_role_policy.json
#   name               = "test-oidc"
# }

# resource "aws_iam_policy" "test_policy" {
#   name = "test-policy"
#   policy = jsonencode({
#     Statement = [{
#       Action = [
#         "s3:ListAllMyBuckets",
#         "s3:GetBucketLocation",
#       ],
#       Effect   = "Allow"
#       Resource = "arn:aws:s3:::*"
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "oidc-policy" {
#   policy_arn = aws_iam_policy.test_policy.arn
#   role       = aws_iam_role.test_oidc.name
# }

# output "role_arn" {
#   value = aws_iam_role.test_oidc.arn

# }