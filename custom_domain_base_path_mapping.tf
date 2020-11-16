resource "aws_api_gateway_domain_name" "customdomain" {
  certificate_arn = aws_acm_certificate_validation.customdomain.certificate_arn
  domain_name     = "api.test.detected.app"
}

resource "aws_api_gateway_domain_name" "detected" {
  domain_name = "test.detected.app"

  certificate_name        = "example-api"
  certificate_body        = file("${path.module}/test.detected.app/detected.crt")
  certificate_chain       = file("${path.module}/test.detected.app/ca.crt")
  certificate_private_key = file("${path.module}/test.detected.app/detected.key")
}

resource "aws_api_gateway_base_path_mapping" "base0" {
  api_id      = aws_api_gateway_rest_api.restapi0.id
  stage_name  = aws_api_gateway_deployment.dev.stage_name
  domain_name = aws_api_gateway_domain_name.detected.domain_name
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "customrecord" {
  name    = aws_api_gateway_domain_name.customdomain.domain_name
  type    = "A"
  zone_id = aws_route53_zone.customdomain.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.customdomain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.customdomain.cloudfront_zone_id
  }
}

# Error: Error Importing aws_route_53 record. Please make sure record ID is in 
# the form ZONEID_RECORDNAME_TYPE e.g. Z4KAPRWWNC7JR_dev_A