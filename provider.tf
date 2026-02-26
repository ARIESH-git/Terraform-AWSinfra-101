provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}
terraform {
  backend "s3" {
    bucket = "terraform-101-bucket-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
