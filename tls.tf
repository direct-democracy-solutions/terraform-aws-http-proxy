resource "aws_acm_certificate" "proxy" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "proxy" {
  certificate_arn         = aws_acm_certificate.proxy.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}


resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.proxy.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.hosted_zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}
