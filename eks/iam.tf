# # EKS clusters make calls to AWS APIs on your behalf, therefore the below role is created
# # We attach policies to this role, so the EKS cluster can do things

# resource "aws_iam_role" "EKSClusterRole" {
#   name = "EKSClusterRolee"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }


# # Kubelet makes API calls to the AWS APIs.  Nodes recieve permissions for these api calls through an IAM instance profile and associated 
# # policies.  Before we can create nodes and register them into the cluster, we must create an IAM role for these ndoes to use when they launch 
# resource "aws_iam_role" "NodeGroupRole" {
#   name = "EKSNodeGroupRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }


# # Attach managed IAM policies to IAM role 

# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.EKSClusterRole.name
# }

# # Allow worker nodes to connect to EKS Clusters (API server - master)
# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.NodeGroupRole.name
# }

# # Read only access to ECR
# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.NodeGroupRole.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.NodeGroupRole.name
# }



