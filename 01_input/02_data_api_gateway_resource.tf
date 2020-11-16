data "aws_api_gateway_rest_api" "restapi0" {
  name = "api-95d8427d"
}

data "aws_api_gateway_resource" "my_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.restapi0.id
  path        = "/api"
}


variable "application" {
  type        = string
  default     = ""
  description = "Application (e.g. `cd` or `clouddrove`)."
}

variable "tags" {
  type        = map
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the REST API "
}

variable "api_key_source" {
  type        = string
  default     = "HEADER"
  description = "The source of the API key for requests. Valid values are HEADER (default) and AUTHORIZER."
}

variable "path_parts" {
  type        = list
  default     = []
  description = "The last path segment of this API resource."
}

variable "uri" {
  type        = list
  default     = []
  description = "The input's URI. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY. For HTTP integrations, the URI must be a fully formed, encoded HTTP(S) URL according to the RFC-3986 specification . For AWS integrations, the URI should be of the form arn:aws:apigateway:{region}:{subdomain.service|service}:{path|action}/{service_api}. region, subdomain and service are used to determine the right endpoint. e.g. arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:012345678901:function:my-func/invocations."
}

variable "credentials" {
  type        = list
  default     = []
  description = "The credentials required for the integration. For AWS integrations, 2 options are available. To specify an IAM Role for Amazon API Gateway to assume, use the role's ARN. To require that the caller's identity be passed through from the request, specify the string arn:aws:iam::*:user/*."
}

variable "stage_variables" {
  type        = list
  default     = []
  description = "A map that defines the stage variables."
}

variable "stage_names" {
  type        = list
  default     = []
  description = "The name of the stage."
}
