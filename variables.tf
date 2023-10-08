variable "api_display_name" {
  type = string
  description = "Display name for the AWS resources"
}

variable "api_mapping_key" {
  type = string
  description = "Proxied requests must begin with this prefix"
}

variable "api_description" {
  type = string
  description = "Description for the API Gateway resource"
}

variable "full_domain_name" {
  type = string
  description = "Domain name for the TLS certificate"
}

variable "hosted_zone_id" {
  type = string
  description = "ID of the Route53 Hosted Zone that routes to the API Gateway"
}

variable "auto_create_route" {
  type = bool
  description = "Automatically create the proxy route and integration"
  default = true
}

variable "target_url" {
  type = string
  description = "URL of the site to proxy. Required if auto_create_route = true; ignored otherwise"
  default = ""
}
