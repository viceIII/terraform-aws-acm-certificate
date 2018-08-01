variable "domains" {
  type = "map"
}

output "transposed_domains" {
  // transpose(map) - Swaps the keys and list values in a map of lists of strings.
  value = "${transpose(var.domains)}"
}

output "transposed_keys" {
  // keys(map) - Returns a lexically sorted list of the map keys.
  value = "${keys(transpose(var.domains))}"
}
