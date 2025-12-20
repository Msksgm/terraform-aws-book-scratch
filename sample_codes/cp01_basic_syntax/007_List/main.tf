variable "pet_name_list" {
  type    = list(string)
  default = ["cat", "dog", "mouse"]
} # ペットの名前をリストで定義

variable "pet_count_list" {
  type    = list(number)
  default = [2, 3, 5]
} # ペットの数をリストで定義

# for (...) inが1個の場合だと、値が展開される
output "pet_in_room" {
  value = [for pet in var.pet_name_list : "There is a ${pet} in the room."]
}

# for (...) inが2個の場合だと、インデックスと値が展開される
output "pets_in_room_count" {
  value = [for index, value in var.pet_count_list : "Index ${index} : ${var.pet_name_list[index]} = ${value}"]
}
