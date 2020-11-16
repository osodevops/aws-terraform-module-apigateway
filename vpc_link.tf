resource "aws_api_gateway_vpc_link" "vpclink" {
    arn         = "Will be known after deployment"
    id          = "Will be known after deployment"
    name        = "" #aws_api_gateway_rest_api.restapi0.name
    tags = {
      Application                    = ""
      Environment                    = "${var.environment}"
      CostCode                       = ""
      SquadName                      = ""
    target_arns = [] # "arn:aws:elasticloadbalancing:eu-west-2:670824338614:loadbalancer/net/api-9-LoadB-RCE24E8FTK2A/e40102e887d0e5ae"
    }
}