################ IAM ROLE - ADMIN EKS ################

data "aws_iam_policy_document" "eks_admin" {
  statement {
    actions = [
      "eks:*"
    ]
    effect = "Allow"

    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_admin" {
  name   = "eks-admin"
  policy = data.aws_iam_policy_document.eks_admin.json
}

resource "aws_iam_role" "eks_admin" {
  name = "eks-admin"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::421716472970:root" #all users within your account can assume the role but still need to establish trust betwen users and role
        }
      }

    ]
  })
}


resource "aws_iam_policy_attachment" "eks_admin" {
  name       = "eks-admin-policy-attachment"
  roles      = [aws_iam_role.eks_admin.name]
  policy_arn = aws_iam_policy.eks_admin.arn
}


# Group

resource "aws_iam_group" "eks_admin" {
  name = "eks-admin"
}

resource "aws_iam_policy_attachment" "eks_admin_assume_role" {
  name       = "eks-admin-attachment"
  groups     = [aws_iam_group.eks_admin.name]
  policy_arn = aws_iam_policy.eks_admin_assume_role.arn
}

data "aws_iam_policy_document" "eks_admin_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"

    resources = [aws_iam_role.eks_admin.arn]
  }
}


resource "aws_iam_policy" "eks_admin_assume_role" {
  name   = "eks-admin-assume-role"
  policy = data.aws_iam_policy_document.eks_admin_assume_role.json
}

resource "aws_iam_user" "eks_admin" {
  name = "administrator"
}


resource "aws_iam_user_group_membership" "eks_admin" {
  user = aws_iam_user.eks_admin.name

  groups = [
    aws_iam_group.eks_admin.name,
  ]
}


# attach eks admin assume role to group  

output "arn_iam" {
  value = aws_iam_role.eks_admin.arn
}



################ IAM ROLE - READONLY EKS ################

data "aws_iam_policy_document" "eks_read_only" {
  statement {
    actions = [
      "eks:DescribeNodeGroups",
      "eks:ListNodeGroups",
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:AccessKubernetesApi",
      "ssm:GetParameter",
      "eks:ListUpdates",
      "eks:ListFargateProfiles"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}


resource "aws_iam_policy" "eks_read_only" {
  name   = "eks-read-only"
  policy = data.aws_iam_policy_document.eks_read_only.json
}


resource "aws_iam_role" "eks_read_only" {
  name = "eks-read-only"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::421716472970:root" #all users within your account can assume the role but still need to establish trust betwen users and role
        }
      }

    ]
  })
}

resource "aws_iam_policy_attachment" "eks_read_only" {
  name       = "eks-admin-policy-attachment"
  roles      = [aws_iam_role.eks_read_only.name]
  policy_arn = aws_iam_policy.eks_read_only.arn
}

# Group

resource "aws_iam_group" "developer_read_only" {
  name = "developer"
}

data "aws_iam_policy_document" "eks_read_only_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"

    resources = [aws_iam_role.eks_read_only.arn]
  }
}

resource "aws_iam_policy" "eks_read_only_assume_role" {
  name   = "eks-read-only-assume-role"
  policy = data.aws_iam_policy_document.eks_read_only_assume_role.json
}

resource "aws_iam_policy_attachment" "eks_read_only_assume_role" {
  name       = "eks-read-only-assume-role-attachment"
  groups     = [aws_iam_group.developer_read_only.name]
  policy_arn = aws_iam_policy.eks_read_only_assume_role.arn
}

resource "aws_iam_user" "developer" {
  name = "developer"
}

resource "aws_iam_user_group_membership" "developer" {
  user   = aws_iam_user.developer.name
  groups = [aws_iam_group.developer_read_only.name]


}

output "developer_role_arn" {
  value = aws_iam_role.eks_read_only.arn
}