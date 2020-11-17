resource "aws_api_gateway_method_settings" "_" {
  rest_api_id = aws_api_gateway_rest_api.profile_api.id
  stage_name  = aws_api_gateway_stage.profile_stage.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = var.api_throttling_burst_limit
    throttling_rate_limit  = var.api_throttling_rate_limit
    metrics_enabled        = var.api_metrics_enabled
    logging_level          = var.api_logging_level
    data_trace_enabled     = var.api_data_trace_enabled
  }
}