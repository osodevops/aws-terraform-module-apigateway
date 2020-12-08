resource "aws_api_gateway_deployment" "profile_api" {

  rest_api_id = aws_api_gateway_rest_api.profile_api.id
  stage_name  = ""

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_base_path_mapping" "test" {
  api_id      = aws_api_gateway_rest_api.profile_api.id
  stage_name  = aws_api_gateway_stage.profile_stage.stage_name
  domain_name = aws_api_gateway_domain_name.example.domain_name
}