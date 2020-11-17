resource "aws_api_gateway_stage" "profile_stage" {
  stage_name    = var.namespace
  rest_api_id   = aws_api_gateway_rest_api.profile_api.id
  deployment_id = aws_api_gateway_deployment.profile_api.id

  xray_tracing_enabled = var.xray_tracing_enabled

}