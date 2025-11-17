module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  eks_managed_node_groups = {
    default = {
      desired_size = var.desired_capacity
      min_size     = 1
      max_size     = var.desired_capacity + 1
      instance_types = [var.node_instance_type]
      # optional: ami_type, disk_size, etc.
    }
  }
}
