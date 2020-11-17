resource "aws_api_gateway_vpc_link" "vpc_link" {
  name = local.vpc_link_name
  target_arns = ["arn:aws:elasticloadbalancing:eu-west-2:670824338614:loadbalancer/net/aeb826dc8301a4d24a19f7bb55956dd4/61372f126f165d37"]
}