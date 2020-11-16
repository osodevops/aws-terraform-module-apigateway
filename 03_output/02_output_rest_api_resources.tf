resource "aws_api_gateway_resource" "resourceapi0" {
    id          = "1a8od8"
    parent_id   = "1ok3dn9mog"
    path        = "/api"
    path_part   = "api"
    rest_api_id = "2795dll430"
}

# aws_api_gateway_resource.resourceapibook0:
resource "aws_api_gateway_resource" "resourceapibook0" {
    id          = "yg6a1l"
    parent_id   = "1a8od8"
    path        = "/api/book"
    path_part   = "book"
    rest_api_id = "2795dll430"
}

resource "aws_api_gateway_resource" "resourceapibookproxy0" {
    id          = "tnvadk"
    parent_id   = "yg6a1l"
    path        = "/api/book/{proxy+}"
    path_part   = "{proxy+}"
    rest_api_id = "2795dll430"
}

resource "aws_api_gateway_resource" "resourceapiauthor0" {
    id          = "8dqylq"
    parent_id   = "1a8od8"
    path        = "/api/author"
    path_part   = "author"
    rest_api_id = "2795dll430"
}

resource "aws_api_gateway_resource" "resourceapiauthorproxy0" {
    id          = "rzp65v"
    parent_id   = "8dqylq"
    path        = "/api/author/{proxy+}"
    path_part   = "{proxy+}"
    rest_api_id = "2795dll430"
}

resource "aws_api_gateway_method" "methodapi0" {
    api_key_required     = false
    authorization        = "AWS_IAM"
    authorization_scopes = []
    http_method          = "ANY"
    id                   = "agm-2795dll430-1a8od8-ANY"
    request_models       = {}
    request_parameters   = {
        "method.request.path.proxy" = true
    }
    resource_id          = "1a8od8"
    rest_api_id          = "2795dll430"
}