variable "environment" {
  description = "Environment descriptor."
  type = string
}

variable "api_name" {
  description = "API Gateway endpoint name"
}

//variable "api_template" {
//  description = "API Gateway OpenAPI 3 template file"
//}

//variable "api_template_vars" {
//  description = "Variables required in the OpenAPI template file"
//  type        = map
//}

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
  vpc_link_name = "test-link"
  stage_name = "development"
//  api_url              = "${aws_api_gateway_deployment.profile_api.invoke_url}${aws_api_gateway_stage.profile_stage.stage_name}"
  api_name             = "${upper(var.environment)}-${upper(var.api_name)}"
}