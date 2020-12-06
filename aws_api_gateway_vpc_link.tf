resource "aws_api_gateway_vpc_link" "vpc_link" {
  count = local.create_api_link
  name = local.vpc_link_name
  target_arns = [var.vpc_link_target_arn]
}