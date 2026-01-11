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

data "aws_caller_identity" "current" {}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = ".cache/lambda_function.zip"
}

resource "aws_lambda_layer_version" "requests_layer" {
  filename            = "./requests.zip"
  layer_name          = "requests_layer"
  description         = "A layer containing numpy library"
  compatible_runtimes = ["python3.12"]
  source_code_hash    = filebase64sha256("./requests.zip")
}

resource "aws_lambda_function" "requests_global_ip" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "requests_global_ip"
  role             = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LambdaBasicExecutionRole"
  handler          = "lambda_function.lambda_handler"
  timeout          = 30
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  layers = [
    aws_lambda_layer_version.requests_layer.arn
  ]
}
