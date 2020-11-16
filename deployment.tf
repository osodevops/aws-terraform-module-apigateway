resource "aws_api_gateway_deployment" "deployment0" {
  depends_on  = [aws_api_gateway_integration.integration0]
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "dev" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.restapi0.id
  deployment_id = aws_api_gateway_deployment.deployment0.id
}