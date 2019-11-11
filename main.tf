resource "aws_acm_certificate" "cert" {
  domain_name       = var.main_domain
  validation_method = "DNS"

  // list of domains that should be SANs in the issued certificate
  subject_alternative_names = keys(transpose(var.domains))
  tags = {
    "terraform workspace" = terraform.workspace
  }
}

# module "transpose" {
#   source  = "convert_map"
#   domains = "${var.domains}"
# }

data "aws_route53_zone" "root" {
  for_each     = var.domains
  name         = each.key
  private_zone = false
}


resource "aws_route53_record" "validation_record" {
  for_each        = transpose(var.domains)
  allow_overwrite = true
  ttl             = "30"
  zone_id         = data.aws_route53_zone.root[each.value[0]].zone_id
  name            = [for x in aws_acm_certificate.cert.domain_validation_options : x.resource_record_name if x.domain_name == each.key][0]
  type            = [for x in aws_acm_certificate.cert.domain_validation_options : x.resource_record_type if x.domain_name == each.key][0]
  records         = [for x in aws_acm_certificate.cert.domain_validation_options : x.resource_record_value if x.domain_name == each.key]
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}
