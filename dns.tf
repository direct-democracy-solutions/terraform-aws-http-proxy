resource "aws_route53_record" "proxy" {
  zone_id = var.hosted_zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.proxy.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.proxy.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_domain_name" "proxy" {
  domain_name = aws_acm_certificate.proxy.domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.proxy.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
