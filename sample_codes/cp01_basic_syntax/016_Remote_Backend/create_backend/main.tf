variable "aws_profile_name" {
  type    = string
  default = "develop"
}

variable "state_buckend_name" {
  type = string
}

provider "aws" {
  profile = var.aws_profile_name
}

# s3バケットの作成
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.state_buckend_name}-terraform-state-bucket"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# バージョニングの有効化
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.state_buckend_name}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Locks Table"
    Environment = "Dev"
  }

  lifecycle {
    prevent_destroy = true
  }

}
