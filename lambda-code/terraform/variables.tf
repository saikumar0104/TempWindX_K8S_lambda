variable "pg_host" { type = string }
variable "pg_port" { type = number }
variable "pg_db"   { type = string }
variable "pg_user" { type = string }
variable "pg_pass" { type = string }

variable "pushgateway_url" { type = string }
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
