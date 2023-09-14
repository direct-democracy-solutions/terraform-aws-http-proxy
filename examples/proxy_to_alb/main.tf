module "proxy" {
  source = "../.."
  api_display_name = "example-alb-proxy"
  api_description = "Transparent proxy to a simple AWS Application Load Balancer"
  api_mapping_key = ""
  full_domain_name = var.domain_name
  hosted_zone_id = var.route53_hosted_zone_id
  auto_create_route = false
}

resource "aws_apigatewayv2_route" "custom_route" {
  api_id    = module.proxy.api_id
  route_key = "$default"
  target    = format("integrations/%s", aws_apigatewayv2_integration.custom_integration.id)
}

resource "aws_apigatewayv2_integration" "custom_integration" {
  api_id             = module.proxy.api_id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = aws_lb_listener.hello.arn
  connection_type = "VPC_LINK"
  connection_id = aws_apigatewayv2_vpc_link.target.id
}
