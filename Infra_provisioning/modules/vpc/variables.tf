variable "name" {}
variable "cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "create_nat" { 
   type = bool
   default = false
}
