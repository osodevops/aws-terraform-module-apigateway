resource "aws_api_gateway_vpc_link" "vpclink" {
    name        = var.aws_api_gateway_rest_api.restapi0.name
    tags = {
      Application                    = "${var.application}"
      Environment                    = "${var.environment}"
      CostCode                       = "${var.costcode}"
      SquadName                      = "${var.squad}"
    }
}