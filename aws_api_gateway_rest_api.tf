resource "aws_api_gateway_rest_api" "profile_api" {
  name           = local.api_name
  api_key_source = "HEADER"

//  policy = data.aws_iam_policy_document.api_gateway_resource_policy.json

  body = data.template_file.api_template.rendered


//  endpoint_configuration {
//    types = ["REGIONAL"]
//  }
}