resource "aws_api_gateway_gateway_response" "BAD_REQUEST_BODY" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code   = "400"
  response_type = "BAD_REQUEST_BODY"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "BAD_REQUEST_PARAMETERS" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code   = "400"
  response_type = "BAD_REQUEST_PARAMETERS"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "UNAUTHORIZED" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code   = "400"
  response_type = "UNAUTHORIZED"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "EXPIRED_TOKEN" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code = "403"
  response_type = "EXPIRED_TOKEN"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "ACCESS_DENIED" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code = "403"
  response_type = "ACCESS_DENIED"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "MISSING_AUTHENTICATION_TOKEN" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code = "403"
  response_type = "MISSING_AUTHENTICATION_TOKEN"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "RESOURCE_NOT_FOUND" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code = "404"
  response_type = "RESOURCE_NOT_FOUND"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "REQUEST_TOO_LARGE" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  status_code = "413"
  response_type = "REQUEST_TOO_LARGE"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "UNSUPPORTED_MEDIA_TYPE" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  response_type = "UNSUPPORTED_MEDIA_TYPE"
  status_code = "415"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "THROTTLED" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  response_type = "THROTTLED"
  status_code = "429"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "AUTHORIZER_CONFIGURATION_ERROR" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  response_type = "AUTHORIZER_CONFIGURATION_ERROR"
  status_code = "500"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "INTEGRATION_FAILURE" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  response_type = "INTEGRATION_FAILURE"
  status_code = "504"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "INTEGRATION_TIMEOUT" {
  rest_api_id = aws_api_gateway_rest_api.restapi0.id
  response_type = "INTEGRATION_TIMEOUT"
  status_code = "504"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
  response_parameters = {
    "gatewayresponse.header.Authorization" = "'Basic'"
  }
}

