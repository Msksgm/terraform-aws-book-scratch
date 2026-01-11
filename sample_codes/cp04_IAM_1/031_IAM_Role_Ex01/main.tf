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

# 信頼関係の定義
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ロールを作成
resource "aws_iam_role" "lambda_role" {
  name               = "S3FullAccess"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# AWSLambdaBasicExecutionRoleマネージドポリシーを追加
resource "aws_iam_role_policy_attachment" "managed_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

