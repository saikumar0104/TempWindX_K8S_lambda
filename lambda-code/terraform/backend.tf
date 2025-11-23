terraform {
  backend "s3" {
    bucket         = "tempwindx-tfstate"   # same or different S3 bucket
    key            = "lambda/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
