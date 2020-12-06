data "template_file" "api_template" {
  template = var.api_template

  vars = {
    connectionId        = aws_api_gateway_vpc_link.vpc_link.*.id[0]
  }
}

