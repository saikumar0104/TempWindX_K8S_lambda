terraform {
  backend "s3" {
    bucket = "tempwindx-tfstate"
    key    = "infra/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}
