# aws_api_gateway_integration.integration0:
resource "aws_api_gateway_integration" "integration0" {
    cache_key_parameters    = []
    cache_namespace         = "1a8od8"
    connection_id           = "vawurb"
    connection_type         = "VPC_LINK"
    http_method             = "ANY"
    id                      = "agi-2795dll430-1a8od8-ANY"
    integration_http_method = "ANY"
    passthrough_behavior    = "WHEN_NO_MATCH"
    request_parameters      = {
        "integration.request.header.Accept-Encoding" = "'identity'"
        "integration.request.path.proxy"             = "method.request.path.proxy"
    }
    request_templates       = {}
    resource_id             = "1a8od8"
    rest_api_id             = "2795dll430"
    timeout_milliseconds    = 29000
    type                    = "HTTP_PROXY"
    uri                     = "http://api-9-LoadB-RCE24E8FTK2A-e40102e887d0e5ae.elb.eu-west-2.amazonaws.com/api"
}

resource "aws_api_gateway_stage" "dev" {
    arn                   = "arn:aws:apigateway:eu-west-2::/restapis/2795dll430/stages/dev"
    cache_cluster_enabled = false
    deployment_id         = "7ahgto"
    execution_arn         = "arn:aws:execute-api:eu-west-2:670824338614:2795dll430/dev"
    id                    = "ags-2795dll430-dev"
    invoke_url            = "https://2795dll430.execute-api.eu-west-2.amazonaws.com/dev"
    rest_api_id           = "2795dll430"
    stage_name            = "dev"
    tags                  = {
        "managedBy" = "amazon-apigateway-ingress-controller"
    }
    variables             = {}
    xray_tracing_enabled  = false
}