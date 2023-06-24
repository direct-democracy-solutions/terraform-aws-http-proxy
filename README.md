# terraform-aws-http-proxy
A module that creates a basic transparent HTTP Proxy with API Gateway.

Useful for things like solving CORS issues when developing for a third-party API.

## Quickstart

Make sure you have a Route53 Hosted Zone set up already.

```hcl
module {
  source  = "direct-democracy-solutions/http-proxy/aws"
  version = "1.0.0"
  api_display_name = "example-dot-com-proxy"
  api_description  = "Transparent proxy to example.com"
  target_url       = "http://example.com"
  api_mapping_key  = ""  # Set this if you want to proxy only the part of the path after a certain prefix
  full_domain_name = "mycoolproxy.mydomain.com"  # The proxy will be addressable here
  hosted_zone_id   = "23AOIPODTNI98"  # Replace with your own hosted zone ID
}
```

The module will create a proxy gateway at the requested location, with a
valid TLS certificate. Logs are streamed to CloudWatch.