resource "aws_api_gateway_rest_api" "masterrestapi" {
  name        = "masterrestapi"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "masterresource" {
  rest_api_id = aws_api_gateway_rest_api.masterrestapi.id
  parent_id   = aws_api_gateway_rest_api.masterrestapi.root_resource_id
  path_part   = "dev"
}

resource "aws_api_gateway_method" "mastermethod" {
  rest_api_id   = aws_api_gateway_rest_api.masterrestapi.id
  resource_id   = aws_api_gateway_resource.masterresource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "masterintegration" {
  rest_api_id = aws_api_gateway_rest_api.masterrestapi.id
  resource_id = aws_api_gateway_resource.masterresource.id
  http_method = aws_api_gateway_method.mastermethod.http_method
  type        = "MOCK"
}

resource "aws_api_gateway_deployment" "masterdeployment" {
  depends_on = [aws_api_gateway_integration.masterintegration]

  rest_api_id = aws_api_gateway_rest_api.masterrestapi.id
  stage_name  = "dev"

  variables = {
    "answer" = "42"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_client_certificate" "dantelecert" {
  description = "certificate for dantele domain"
}

resource "aws_api_gateway_domain_name" "masterdomain" {
  domain_name             = "dantele.fi"
  # certificate_arn         = aws_acm_certificate_validation.example.certificate_arn
  certificate_name        = "dantele"
  certificate_body        = file("${path.module}/dantele.fi/dantele.crt")
  certificate_chain       = file("${path.module}/dantele.fi/danteleca.crt")
  certificate_private_key = file("${path.module}/dantele.fi/dantele.key")
}

resource "aws_api_gateway_base_path_mapping" "dev" {
  api_id      = aws_api_gateway_rest_api.masterrestapi.id
  stage_name  = aws_api_gateway_deployment.masterdeployment.stage_name
  domain_name = aws_api_gateway_domain_name.masterdomain.domain_name
}