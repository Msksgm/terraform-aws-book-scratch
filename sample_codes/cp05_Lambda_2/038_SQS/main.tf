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

#標準キューの作成
resource "aws_sqs_queue" "standard_quer" {
  name                       = "my-standard-queue"
  message_retention_seconds  = 43200 #12h
  receive_wait_time_seconds  = 0     # 0より大きくするとロングボーリング
  visibility_timeout_seconds = 30    # 可視性タイムアウト
}

# FIFOキューの作成
resource "aws_sqs_queue" "fifo_queue" {
  name                        = "my-fifo-queue.fifo" # FIFOキュー名は .fifo で終わる必要があり
  fifo_queue                  = true
  content_based_deduplication = true  # true=短時間内の重複したメッセージをまとめる
  message_retention_seconds   = 43200 # 12h
  receive_wait_time_seconds   = 10    #0より大きくするとロングボーリング
  visibility_timeout_seconds  = 30    #可視性タイムアウト
}
