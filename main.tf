resource "aws_acm_certificate" "cert" {
  domain_name       = "${main_domain}"
  validation_method = "DNS"

  // list of domains that should be SANs in the issued certificate
  subject_alternative_names = "${keys(transpose(var.domains))}"

  validation_method = "DNS"

  tags {
    "terraform workspace" = "${terraform.workspace}"
  }
}

module "transpose" {
  source  = "convert_map"
  domains = "${var.domains}"
}

data "aws_route53_zone" "root" {
  count        = "${length(module.transpose.transposed_keys)}"
  name         = "${element(module.transpose.transposed_domains[lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "domain_name")], 0)}"
  private_zone = false
}

resource "aws_route53_record" "validation_record" {
  count   = "${length(module.transpose.transposed_keys)}"
  zone_id = "${element(data.aws_route53_zone.root.*.zone_id, count.index)}"
  name    = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_type")}"
  ttl     = "30"
  records = ["${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_value")}"]
}
