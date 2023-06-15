variable "api_display_name" {
  type = string
  description = "Display name for the API Gateway created by the module"
}

variable "api_stage_name" {
  type = string
  description = "Name for the API Gateway stage"
}

variable "api_mapping_key" {
  type = string
  description = "Proxied requests must begin with this prefix"
}

variable "api_gateway_description" {
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

variable "target_url" {
  type = string
  description = "URL of the site to proxy"
}
