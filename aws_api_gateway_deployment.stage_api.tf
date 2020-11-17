resource "aws_api_gateway_deployment" "profile_api" {

  rest_api_id = aws_api_gateway_rest_api.profile_api.id
  stage_name  = ""

  lifecycle {
    create_before_destroy = true
  }
}
