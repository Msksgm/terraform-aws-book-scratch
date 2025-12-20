provider "local" {}

variable "files" {
  type = map(string)
  default = {
    "example1.tx" = "Hello, this is example 1",
    "example2.tx" = "Hello, this is example 2",
    "example3.tx" = "Hello, this is example 3"
  }
}

resource "local_file" "example" {
  for_each = var.files
  filename = "${path.module}/${each.key}.txt"
  content  = each.value
}
