  data "template_file" "api_template" {
  template = file("${path.module}/templates/profile_api.yml")

  vars = {
    connectionId        = aws_api_gateway_vpc_link.vpc_link.id
  }
}

