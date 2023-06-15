module "proxy" {
  source = "../.."
  api_display_name = "example-dot-com-proxy"
  api_description = "Transparent proxy to example.com"
  api_mapping_key = ""
  target_url = "http://example.com"
  full_domain_name = var.domain_name
  hosted_zone_id = var.route53_hosted_zone_id
}