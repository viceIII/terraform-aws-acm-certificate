# AWS ACM Certificate

Terraform module which creates ACM certificate within validation over Route53 CNAME record.

```
module "aws-acm-certificate-main" {
  source = "viceIII/acm-certificate/aws"

  # Certificate main domain name
  main_domain = "example.com"

  # Additional names
  # map of Route53 domain names as keys,
  # and list of domains witch you want to validate and include in certificate  
  domains = {
    "example.com"         = ["example.com", "www.example.com"]
    "dev.example.com" = ["*.dev.example.com"]
  }
}
```

Retrieve generated certificate as data resource
```
data "aws_acm_certificate" "main" {
  domain = "${var.main_domain}"
  # most_recent = true
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}
```
