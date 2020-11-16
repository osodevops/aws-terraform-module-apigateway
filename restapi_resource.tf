resource "aws_api_gateway_resource" "resourceapi0" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  parent_id   = aws_api_gateway_rest_api.restapi0.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "resourceapibook0" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  parent_id   = aws_api_gateway_resource.resourceapi0.id
  path_part   = "book"
}

resource "aws_api_gateway_resource" "resourceapibookproxy0" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  parent_id   = aws_api_gateway_resource.resourceapibook0.id
  path_part   = "'{proxy+}'"
}

resource "aws_api_gateway_resource" "resourceapiauthor0" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  parent_id   = aws_api_gateway_resource.resourceapi0.id
  path_part   = "author"
}

resource "aws_api_gateway_resource" "resourceapiauthorproxy0" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  parent_id   = aws_api_gateway_resource.resourceapiauthor0.id
  path_part   = "'{proxy+}'"
}

resource "aws_api_gateway_method" "methodapi1" {
  rest_api_id   = aws_api_gateway_rest_api.restapi0.id
  resource_id   = aws_api_gateway_resource.resourceapi0.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  resource_id = aws_api_gateway_resource.resourceapibook0.id
  http_method = aws_api_gateway_method.methodapi0.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integrationresponse0" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  resource_id = aws_api_gateway_resource.resourceapiauthor0.id
  http_method = aws_api_gateway_method.methodapi0.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}