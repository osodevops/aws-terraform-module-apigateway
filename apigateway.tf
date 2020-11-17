resource "aws_api_gateway_rest_api" restapi0 {
    name                     = "testbb"
    api_key_source           = "HEADER"
    binary_media_types       = ["AWS::NoValue"]
    minimum_compression_size = -1
    policy                   = jsonencode(
        {
            Statement = [
                {
                    Action    = "execute-api:Invoke"
                    Effect    = "Allow"
                    Principal = {
                        AWS = "arn:aws:iam::838837044885:user/*"
                    }
                    Resource  = "*"
                },
            ]
            Version   = "2012-10-17"
        }
    )
    tags = {
      Application                    = "${var.application}"
      Environment                    = "${var.environment}"
      CostCode                       = "${var.costcode}"
      SquadName                      = "${var.squad}"
    }

    endpoint_configuration {
        types            = [
            "EDGE",
        ]
        vpc_endpoint_ids = []
    }
}

resource "aws_api_gateway_method" "method0"{
  rest_api_id          = ${aws_api_gateway_rest_api.restapi0.id}
  resource_id          = ${aws_api_gateway_resource.restapi0.root_resource_id}
  api_key_required     = false
  http_method          = "ANY"
  authorization        = "AWS_IAM"
  authorization_scopes = []
  request_models       = {}
  request_parameters   = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_method_settings" "s" {
  rest_api_id = ${aws_api_gateway_rest_api.restapi0.id}
  stage_name  = ${aws_api_gateway_stage.default.stage_name}
  method_path = "${aws_api_gateway_resource.default.path_part}/${aws_api_gateway_method.default.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "integration0" {
  rest_api_id = ${aws_api_gateway_rest_api.restapi0.id}
  resource_id = ${aws_api_gateway_resource.restapi0.root_resource_id}
  http_method = ${aws_api_gateway_method.default.http_method}
  type        = "MOCK"
}