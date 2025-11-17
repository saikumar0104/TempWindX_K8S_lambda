variable "cluster_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "node_instance_type" { default = "t3.small" }
variable "desired_capacity" { default = 2 }
variable "region" { default = "ap-south-1" }

