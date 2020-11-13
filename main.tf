resource "aws_api_gateway_rest_api" "default" {
  count = var.enabled ? 1 : 0

  name                     = var.name
  description              = var.description
  binary_media_types       = var.binary_media_types
  minimum_compression_size = var.minimum_compression_size
  api_key_source           = var.api_key_source

  endpoint_configuration {
    types = var.types
  }
}

# Description : Terraform module to create Api Gateway resource on AWS.
resource "aws_api_gateway_resource" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0

  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  parent_id   = aws_api_gateway_rest_api.default.*.root_resource_id[0]
  path_part   = element(var.path_parts, count.index)
}

# Description : Terraform module to create Api Gateway model on AWS.
resource "aws_api_gateway_model" "default" {
  count        = var.model_count > 0 ? var.model_count : 0
  rest_api_id  = aws_api_gateway_rest_api.default.*.id[0]
  name         = element(var.model_names, count.index)
  description  = length(var.model_descriptions) > 0 ? element(var.model_descriptions, count.index) : ""
  content_type = element(var.content_types, count.index)

  schema = <<EOF
{"type":"object"}
EOF
}

# Description : Terraform module to create Api Gateway Method resource on AWS.
resource "aws_api_gateway_method" "default" {
  count = length(var.path_parts) > 0 ? length(var.path_parts) : 0

  rest_api_id          = aws_api_gateway_rest_api.default.*.id[0]
  resource_id          = aws_api_gateway_resource.default.*.id[count.index]
  http_method          = element(var.http_methods, count.index)
  authorization        = length(var.authorizations) > 0 ? element(var.authorizations, count.index) : "NONE"
  authorizer_id        = length(var.authorizer_ids) > 0 ? element(var.authorizer_ids, count.index) : null
  authorization_scopes = length(var.authorization_scopes) > 0 ? element(var.authorization_scopes, count.index) : null
  api_key_required     = length(var.api_key_requireds) > 0 ? element(var.api_key_requireds, count.index) : null
  request_models       = length(var.request_models) > 0 ? element(var.request_models, count.index) : { "application/json" = "Empty" }
  request_validator_id = length(var.request_validator_ids) > 0 ? element(var.request_validator_ids, count.index) : null
  request_parameters   = length(var.request_parameters) > 0 ? element(var.request_parameters, count.index) : {}
}

# Description : Terraform module to create Api Gateway Method Response resource on AWS.
resource "aws_api_gateway_method_response" "default" {
  count               = length(aws_api_gateway_method.default.*.id)
  rest_api_id         = aws_api_gateway_rest_api.default.*.id[0]
  resource_id         = aws_api_gateway_resource.default.*.id[count.index]
  http_method         = aws_api_gateway_method.default.*.http_method[count.index]
  status_code         = element(var.status_codes, count.index)
  response_models     = length(var.response_models) > 0 ? element(var.response_models, count.index) : {}
  response_parameters = length(var.response_parameters) > 0 ? element(var.response_parameters, count.index) : {}
}

resource "aws_api_gateway_method" "options_method" {
  count         = length(var.path_parts) > 0 ? length(var.path_parts) : 0
  rest_api_id   = aws_api_gateway_rest_api.default.*.id[0]
  resource_id   = aws_api_gateway_resource.default.*.id[count.index]
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
  count       = length(aws_api_gateway_method.default.*.id)
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[count.index]
  http_method = aws_api_gateway_method.options_method.*.http_method[count.index]
  status_code = "200"

  response_models = { "application/json" = "Empty" }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }

  depends_on = [aws_api_gateway_method.options_method]
}

# Module      : Api Gateway Integration
# Description : Terraform module to create Api Gateway Integration resource on AWS.
resource "aws_api_gateway_integration" "default" {
  count                   = length(aws_api_gateway_method.default.*.id)
  rest_api_id             = aws_api_gateway_rest_api.default.*.id[0]
  resource_id             = aws_api_gateway_resource.default.*.id[count.index]
  http_method             = aws_api_gateway_method.default.*.http_method[count.index]
  integration_http_method = length(var.integration_http_methods) > 0 ? element(var.integration_http_methods, count.index) : "POST"
  type                    = length(var.integration_types) > 0 ? element(var.integration_types, count.index) : "AWS_PROXY"
  connection_type         = length(var.connection_types) > 0 ? element(var.connection_types, count.index) : "INTERNET"
  connection_id           = length(var.connection_ids) > 0 ? element(var.connection_ids, count.index) : ""
  uri                     = length(var.uri) > 0 ? element(var.uri, count.index) : ""
  credentials             = length(var.credentials) > 0 ? element(var.credentials, count.index) : ""
  request_parameters      = length(var.integration_request_parameters) > 0 ? element(var.integration_request_parameters, count.index) : {}
  request_templates       = length(var.request_templates) > 0 ? element(var.request_templates, count.index) : {}
  passthrough_behavior    = length(var.passthrough_behaviors) > 0 ? element(var.passthrough_behaviors, count.index) : null
  cache_key_parameters    = length(var.cache_key_parameters) > 0 ? element(var.cache_key_parameters, count.index) : []
  cache_namespace         = length(var.cache_namespaces) > 0 ? element(var.cache_namespaces, count.index) : ""
  content_handling        = length(var.content_handlings) > 0 ? element(var.content_handlings, count.index) : null
  timeout_milliseconds    = length(var.timeout_milliseconds) > 0 ? element(var.timeout_milliseconds, count.index) : 29000
  depends_on              = [aws_api_gateway_method.default]
}

# Module      : Api Gateway Integration Response
# Description : Terraform module to create Api Gateway Integration Response resource on AWS for creating api.
resource "aws_api_gateway_integration_response" "default" {
  count       = length(aws_api_gateway_integration.default.*.id)
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[count.index]
  http_method = aws_api_gateway_method.default.*.http_method[count.index]
  status_code = aws_api_gateway_method_response.default.*.status_code[count.index]

  response_parameters = length(var.integration_response_parameters) > 0 ? element(var.integration_response_parameters, count.index) : {}
  response_templates  = length(var.response_templates) > 0 ? element(var.response_templates, count.index) : {}
  content_handling    = length(var.response_content_handlings) > 0 ? element(var.response_content_handlings, count.index) : null
}

resource "aws_api_gateway_integration" "options_integration" {
  count       = length(aws_api_gateway_method.default.*.id)
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[count.index]
  http_method = aws_api_gateway_method.options_method.*.http_method[count.index]

  type             = "MOCK"
  content_handling = "CONVERT_TO_TEXT"

  depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count       = length(aws_api_gateway_integration.options_integration.*.id)
  rest_api_id = aws_api_gateway_rest_api.default.*.id[0]
  resource_id = aws_api_gateway_resource.default.*.id[count.index]
  http_method = aws_api_gateway_method.options_method.*.http_method[count.index]
  status_code = aws_api_gateway_method_response.options_200.*.status_code[count.index]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,DELETE,GET,HEAD,PATCH,POST,PUT'"
  }

  depends_on = [
    aws_api_gateway_method_response.options_200,
    aws_api_gateway_integration.options_integration,
  ]
}

# Module      : Api Gateway Deployment
# Description : Terraform module to create Api Gateway Deployment resource on AWS.
resource "aws_api_gateway_deployment" "default" {
  count = var.deployment_enabled ? 1 : 0

  rest_api_id       = aws_api_gateway_rest_api.default.*.id[0]
  stage_name        = var.stage_name
  description       = var.description
  stage_description = var.stage_description
  variables         = var.variables
  depends_on        = [aws_api_gateway_method.default, aws_api_gateway_integration.default]
}

# Module      : Api Gateway Stage
# Description : Terraform module to create Api Gateway Stage resource on AWS.
resource "aws_api_gateway_stage" "default" {
  count = var.deployment_enabled && var.stage_enabled && length(var.stage_names) > 0 ? length(var.stage_names) : 0

  rest_api_id           = aws_api_gateway_rest_api.default.*.id[0]
  deployment_id         = aws_api_gateway_deployment.default.*.id[0]
  stage_name            = element(var.stage_names, count.index)
  cache_cluster_enabled = length(var.cache_cluster_enableds) > 0 ? element(var.cache_cluster_enableds, count.index) : false
  cache_cluster_size    = length(var.cache_cluster_sizes) > 0 ? element(var.cache_cluster_sizes, count.index) : null
  client_certificate_id = length(var.client_certificate_ids) > 0 ? element(var.client_certificate_ids, count.index) : (var.cert_enabled ? aws_api_gateway_client_certificate.default.*.id[0] : "")
  description           = length(var.descriptions) > 0 ? element(var.descriptions, count.index) : ""
  documentation_version = length(var.documentation_versions) > 0 ? element(var.documentation_versions, count.index) : null
  variables             = length(var.stage_variables) > 0 ? element(var.stage_variables, count.index) : {}
  xray_tracing_enabled  = length(var.xray_tracing_enabled) > 0 ? element(var.xray_tracing_enabled, count.index) : false
}

# Module      : Api Gateway Gateway Response
# Description : Terraform module to create Api Gateway Gateway Response resource on AWS.
resource "aws_api_gateway_gateway_response" "default" {
  count         = var.gateway_response_count > 0 ? var.gateway_response_count : 0
  rest_api_id   = aws_api_gateway_rest_api.default.*.id[0]
  response_type = element(var.response_types, count.index)
  status_code   = length(var.gateway_status_codes) > 0 ? element(var.gateway_status_codes, count.index) : ""

  response_templates = length(var.gateway_response_templates) > 0 ? element(var.gateway_response_templates, count.index) : {}

  response_parameters = length(var.gateway_response_parameters) > 0 ? element(var.gateway_response_parameters, count.index) : {}
}

# Module      : Api Gateway VPC Link
# Description : Terraform module to create Api Gateway VPC Link resource on AWS.
resource "aws_api_gateway_vpc_link" "default" {
  count       = var.vpc_link_count > 0 ? var.vpc_link_count : 0
  name        = element(var.vpc_link_names, count.index)
  description = length(var.vpc_link_descriptions) > 0 ? element(var.vpc_link_descriptions, count.index) : ""
  target_arns = element(var.target_arns, count.index)
}
