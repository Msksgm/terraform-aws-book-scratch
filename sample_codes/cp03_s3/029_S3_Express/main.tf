terraform {
  backend "local" {
    path = ".cache/terraform.tfstate"
  }
}

variable "aws_profile_name" {
  type    = string
  default = "develop"
}

provider "aws" {
  profile = var.aws_profile_name
}

variable "bucket_name" {
  type = string # terraform.tfvarsで規定
}

variable "az_id" {
  type    = string
  default = "apne1-az4"
  # ap-northeast1のリージョンのAZ4, 2024/10現在az1とaz4のみ対応。マネコンで要確認
}

resource "aws_s3_directory_bucket" "examaple" {
  bucket        = "${var.bucket_name}--${var.az_id}--x-s3" # バケットの命名規則
  force_destroy = true                                     # 開発用
  location {
    name = var.az_id # アベイラビリティゾーン（AZ）を指定する
  }
}
