variable "aws_profile_name" {
  type    = string
  default = "develop"
}

provider "aws" {
  profile = var.aws_profile_name
}

# 現在のAWSアカウント情報を取得
data "aws_caller_identity" "current" {}

# 現在のリージョンを取得
data "aws_region" "current" {}

# 現在のリージョンを取得
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "current_region" {
  value = data.aws_region.current.name
}

# 演習問題
output "role_name" {
  value = "ロール名:arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LambdaExecutionRole"
}

output "lambda_function_name" {
  value = "Lambda関数名:arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:EmailSendingLambda"
}
