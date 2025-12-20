provider "local" {}

locals {
  flowers = ["lilac", "daylily", "lavender", "sunflower"]
  months  = [5, 6, 7, 8]
}

resource "local_file" "example" {
  for_each = { for i in range(length(local.flowers)) : local.months[i] => local.flowers[i] }
  filename = "${path.module}/month0${each.key}.txt"
  content  = "moth = ${each.key}, flower = \"${each.value}\""
}

