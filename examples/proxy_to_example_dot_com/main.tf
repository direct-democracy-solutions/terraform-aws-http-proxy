module "proxy" {
  source = "../.."
  api_display_name = "example-dot-com-proxy"
  api_gateway_description = "Transparent proxy to example.com"
  api_stage_name = "prod"
  api_mapping_key = "proxy"
  target_url = "http://example.com"
  full_domain_name = var.domain_name
  hosted_zone_id = var.route53_hosted_zone_id
}