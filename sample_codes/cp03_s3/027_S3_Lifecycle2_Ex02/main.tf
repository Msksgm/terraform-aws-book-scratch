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

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "lifecycle2_ex02" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_object" "lifecycle2_ex02" {
  bucket      = aws_s3_bucket.lifecycle2_ex02.bucket
  key         = "lifecycle2_ex02/numpy.zip" # フォルダのように見えるが、厳密にはオブジェクトのプレフィックスによって再現される擬似フォルダ構造
  source      = "./numpy.zip"
  source_hash = filemd5("./numpy.zip")
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = ".cache/lambda_function.zip"
}

resource "aws_lambda_layer_version" "numpy_layer" {
  s3_bucket           = aws_s3_bucket.lifecycle2_ex02.bucket
  s3_key              = aws_s3_object.lifecycle2_ex02.key
  layer_name          = "numpy_layer"
  description         = "A layer containing numpy library"
  compatible_runtimes = ["python3.12"]
  source_code_hash    = filebase64sha256("./numpy.zip")
}

resource "aws_lambda_function" "numpy_linear_algebra" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "numpy_linear_algebra"
  role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LambdaBasicExecutionRole"
  handler          = "lambda_function.lambda_handler"
  timeout          = 30
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  layers = [
    aws_lambda_layer_version.numpy_layer.arn # 追加したレイヤーを指定
  ]
}
