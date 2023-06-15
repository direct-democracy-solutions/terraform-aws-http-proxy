terraform {
  required_version = ">= 1.4.0"
}

locals {
  domain_name = var.full_domain_name
}

resource "aws_apigatewayv2_api" "proxy" {
  name                         = var.api_display_name
  description                  = var.api_description
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = true
}

resource "aws_apigatewayv2_stage" "proxy" {
  api_id        = aws_apigatewayv2_api.proxy.id
  name          = "default"
  deployment_id = aws_apigatewayv2_deployment.proxy.id
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.proxy.arn
    format          = join(" ", [
      "$context.identity.sourceIp",
      "$context.identity.caller",
      "$context.identity.user",
      "[$context.requestTime]",
      "$context.httpMethod",
      "$context.resourcePath",
      "$context.protocol",
      "$context.status",
      "$context.responseLength",
      "$context.requestId",
      "$context.extendedRequestId"
    ])
  }
  default_route_settings {
    detailed_metrics_enabled = true
    throttling_rate_limit    = 1000
    throttling_burst_limit   = 1000
  }
}

resource "aws_apigatewayv2_api_mapping" "proxy" {
  api_id      = aws_apigatewayv2_api.proxy.id
  domain_name = aws_apigatewayv2_domain_name.proxy.domain_name
  stage       = aws_apigatewayv2_stage.proxy.id
  api_mapping_key = var.api_mapping_key
}

resource "aws_apigatewayv2_deployment" "proxy" {
  api_id = aws_apigatewayv2_api.proxy.id

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_api.proxy),
      jsonencode(aws_apigatewayv2_integration.proxy),
      jsonencode(aws_apigatewayv2_route.proxy),
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_route" "proxy" {
  api_id    = aws_apigatewayv2_api.proxy.id
  route_key = "$default"
  target    = format("integrations/%s", aws_apigatewayv2_integration.proxy.id)
}

resource "aws_apigatewayv2_integration" "proxy" {
  api_id             = aws_apigatewayv2_api.proxy.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.target_url
}
