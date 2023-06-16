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

Note: due to a [bug](https://github.com/hashicorp/terraform-provider-aws/issues/32025)
in the AWS provider, the first attempt to create the proxy will most
likely fail. It happens because the TLS certificate is
eventually-consistent and the provider tries to create dependent
resources before the certificate is ready. Re-applying after the initial
failure should fix the problem.

The module will create a proxy gateway at the requested location, with a
valid TLS certificate. Logs are streamed to CloudWatch.