# Certificate main domain name
variable "main_domain" {
  type = string
}

# map of Route53 domain names as keys,
# and list of domains witch you want to validate and include in certificate
variable "domains" {
  type = map(list(string))
}

