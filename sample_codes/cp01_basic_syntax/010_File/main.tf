provider "local" {}

resource "local_file" "example" {
  content  = "ローカルファイルの変更テスト"
  filename = "${path.module}/example.txt"
}
