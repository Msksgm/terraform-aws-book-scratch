provider "local" {}

locals {
  flowers = ["lilac", "daylily", "lavender", "sunflower"]
  months  = [5, 6, 7, 8]
}

output "flowers_of_month" {
  value = { for i in range(length(local.flowers)) : "${local.flowers[i]}" => "${local.months[i]}" }
}
