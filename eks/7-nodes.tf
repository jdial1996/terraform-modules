# Create workder nodegroups for EKS cluster
# Nodegroups will also need their own IAM role

resource "aws_iam_role" "nodes_role" {
    name = "eks-node-group-role"
    # jsonencode() convers an object to json
    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}

# Policies - EKS node kubelet makes calls to AWS APIs on your behalf

# This policy grants access to EC2 and EKS
resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.nodes_role.name
}


resource "aws_iam_role_policy_attachment" "eks-worker-node-cni-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.nodes_role.name
}


# This policy allows the worker nodes to download and run docker images from an ECR repository
resource "aws_iam_role_policy_attachment" "eks-worker-node-ecr-policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.nodes_role.name
}


# NODEGROUPS

# Associates nodegroup with our EKS cluster and specify the subnets in which you want to run your nodes
resource "aws_eks_node_group" "private_nodes" {
    cluster_name = aws_eks_cluster.eks-cluster.name
    node_role_arn = aws_iam_role.nodes_role.arn

    subnet_ids = [
            aws_subnet.private-eu-west-2a.id,
            aws_subnet.private-eu-west-2b.id,
            aws_subnet.private-eu-west-2c.id,
    ]

    capacity_type = "ON_DEMAND"
# EKS by itself will not autosclae your nodes.  We also need to deploy the cluster autoscaler.  We can however define minimum and maximum number of nodes
    scaling_config {
        desired_size = 1
        max_size = 5
        min_size = 0
    }

    update_config {
        # desired number of unavailable nodes during nodegroup updates
        max_unavailable = 1
    }

# create labels and taints for your pods here 
    labels = {
        role = "general"
    }
}

    # taint= {}
    # }

    # if you want to create custom configuration for your nodes, use a launch tempalte.  for example, if you need to add extra discks to your workers
    # launch_template = {
    #     name = ""
    #     versoin = ""
    # }



    # start at 7:05