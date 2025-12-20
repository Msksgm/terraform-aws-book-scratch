provider "local" {}

variable "pet_count_map" {
  type = map(number)
  default = {
    cat    = 2
    dog    = 3
    rabbit = 5
  }
}

resource "local_file" "example" {
  for_each = var.pet_count_map
  filename = "${path.module}/pet_${each.key}.txt"
  content  = "${each.value} ${each.key}(s) are in the room."
}
