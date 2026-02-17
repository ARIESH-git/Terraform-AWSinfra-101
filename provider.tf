provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}
resource "aws_s3_bucket" "example" {
bucket = "terraform-101-bucket"
tags = {
  Name        = "My Terraform Bucket"
}