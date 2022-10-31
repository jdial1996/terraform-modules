# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "18.7.2" # module version 

#   cluster_name    = var.eks_cluster_name
#   cluster_version = var.eks_cluster_version # k8s version
#   enable_irsa     = var.enable_irsa   
#   subnet_ids      = module.vpc.private_subnets
#     # cluster_create_timeout          = "1h" # amount of time it takes for cluster creation to fail 
#   cluster_endpoint_private_access = true # allow our private endpoints to connect to k8s and join the cluster automatically 
#   cluster_endpoint_public_access  = true
#   vpc_id                          = module.vpc.vpc_id # vpc the cluster will be in 


#   # kubeconfig

#   # write_kubeconfig   = var.create_kubeconfig
#   # config_output_path = pathexpand("~/.kube/config")

#   eks_managed_node_groups = {
#     ng1 = {
#       min_size     = lookup(var.node_group, "min")
#       max_size     = lookup(var.node_group, "max")
#       desired_size = lookup(var.node_group, "desired")
#       instance_types = [lookup(var.node_group, "instance_type")]
#       capacity_type  = lookup(var.node_group, "capacity_type")

#       create_launch_templatse = false #set this to false to allow the eks default launch tempalte
#       launch_template_name   = ""

#       tags = {
#         "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
#         "k8s.io/cluster-autoscaler/enabled"             = "TRUE"
#       }
#     }
#   }
# }
  
# # Create dummy service and then public loadbalancer

# # create dummy service
# #  k8s provider
# # create public ingress resource to create loadbalancer
# #   k8s provider ingress resource
# # create dns records for path based urls
# #   ingress class? 
