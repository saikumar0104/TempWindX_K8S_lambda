variable "name" {
  description = "Name prefix for RDS resources"
  type        = string
  default     = "myapp"
}

variable "db_name" {
  description = "Default database name to create"
  type        = string
  default     = "mydatabase"
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = "admin123"
}

variable "password" {
  description = "Master DB password"
  type        = string
  default     = "Admin123"   # For testing only
  sensitive   = true
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether RDS should be publicly accessible"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for RDS"
  type        = list(string)
  default     = []
}

