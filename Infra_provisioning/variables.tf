variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project prefix for naming"
  type        = string
  default     = "tempwindx"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs (one per AZ). If empty and create_nat_gateway = false, nodes will use public subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateway (costly). Set false for cheaper setup (nodes in public subnets)."
  type        = bool
  default     = false
}

variable "node_instance_type" {
  description = "EKS node instance type (cost-effective default)"
  type        = string
  default     = "t3.small"
}

variable "node_desired_capacity" {
  description = "Number of worker nodes desired"
  type        = number
  default     = 1
}

variable "db_allocated_storage" {
  description = "RDS allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "RDS instance class (cost-conscious default)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "testdb"
}

variable "db_username" {
  description = "RDS admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS admin password (for practice only; store securely for prod)"
  type        = string
  default     = "admin"
}

variable "enable_public_rds" {
  description = "If true RDS will be publicly accessible (ok for practice, not for prod)"
  type        = bool
  default     = true
}

