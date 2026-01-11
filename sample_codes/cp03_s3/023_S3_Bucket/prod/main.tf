terraform {
  backend "local" {
    path = ".cache/terraform.tfstate"
  }
}

variable "aws_profile_name" {
  type    = string
  default = "develop"
}

variable "bucket_name" {
  type = string
}

provider "aws" {
  profile = var.aws_profile_name
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  lifecycle {
    # 削除できなくするオプション
    # prevent_destroy = true
    # false にすると削除できる
    prevent_destroy = false
  }
}
