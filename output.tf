output "main_restapi_id" {
  value = aws_api_gateway_rest_api.restapi0.id
  description = "The ID of the main REST API."
}

output "main_restapi_execution_arn" {
  value       = aws_api_gateway_rest_api.restapi0.execution_arn
  description = "The Execution ARN of the main REST API."
}

output "method_ids" {
  value       = join("", aws_api_gateway_method.*.id)
  description = "The ID of a REST API method."
}

output "resource_ids" {
  value = join("", aws_api_gateway_resource.*.id)
  description = "The ID of a REST API resource."
}

output "resourceapibook0_id" {
  value = aws_api_gateway_resource.resourceapibook0.id
}

output "resourceapibookproxy0_id" {
  value = aws_api_gateway_resource.resourceapibookproxy0.id
}

output "resourceapiauthor0_id" {
  value = aws_api_gateway_resource.resourceapiauthor0.id
}

output "resourceapiauthorproxy0_id" {
  value = aws_api_gateway_resource.resourceapiauthorproxy0.id
}

output "integration_ids" {
  value = join("", aws_api_gateway_integration.*.id)
  description = "The ID of the integration between a REST API and the backend."
}

output "integration_connection_ids" {
  value = join("", aws_api_gateway_integration.*.connection_id)
  description = "The ID of the integration_connection between a REST API and the backend."
}

output "integration0_id" {
  value = aws_api_gateway_integration.integration0.id
}

output "integration_connection_id" {
  value = aws_api_gateway_integration.integration0.connection_id
}

output "stage_ids" {
  value = join("", aws_api_gateway_stage.*.id)
  description = "The ID of the REST API stage."
}

output "stage_arns" {
  value = join("", aws_api_gateway_stage.*.arn)
  description = "The ARN of the REST API stage."
}

output "stage_execution_arns" {
  value = join("", aws_api_gateway_stage.*.execution_arn)
  description = "The EXECUTION_ARN of the REST API stage."
}