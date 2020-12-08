variable "environment" {
  description = "Environment descriptor."
  type = string
}
variable "api_fqdn" {
  type = string
  default = ""
}

variable "api_name" {
  description = "API Gateway endpoint name"
}

variable "vpc_link_target_arn" {
  type = string
  description = "Private VPC Link to internal load balancer."
}

variable "api_template" {
  description = "API Gateway OpenAPI 3 template file"
}

variable "hosted_zone_name" {
  type = string
}

variable "api_throttling_rate_limit" {
  description = "API Gateway total requests across all API's within a REST endpoint"
}

variable "api_throttling_burst_limit" {
  description = "API Gateway total concurrent connections allowed for all API's within a REST endpoint"
}

variable "api_metrics_enabled" {
  description = "Enables detailed API Gateway metrics"
  type        = bool
  default     = false
}

variable "api_logging_level" {
  description = " (Optional) Specifies the logging level for this method, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are OFF, ERROR, and INFO."
  type        = string
  default     = "OFF"
}

variable "api_data_trace_enabled" {
  description = "(Optional) Specifies whether data trace logging is enabled for this method, which effects the log entries pushed to Amazon CloudWatch Logs."
  type        = bool
  default     = false
}

variable "xray_tracing_enabled" {
  description = "Enables the XRay tracing and will create the necessary IAM permissions "
  type        = bool
  default     = false
}

variable "allowed_range" {
  type = list(string)
}

locals {
  create_api_link = var.vpc_link_target_arn == "" ? 0 : 1
  vpc_link_name   = "${lower(var.environment)}-${lower(var.api_name)}-link"
  stage_name      = "staging"
}