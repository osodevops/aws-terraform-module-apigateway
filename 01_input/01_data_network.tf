data "aws_vpcs" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${upper(var.common_tags["Environment"])}-VPC-EUW2"]
  }
}

data "aws_vpc" "vpc" {
  id = "${data.aws_vpcs.vpc.ids[0]}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpcs.vpc.ids[0]}"

  tags {
    Type = "Private*"
  }
}

data "aws_subnet" "private" {
  count = "${length(data.aws_subnet_ids.private.ids)}"
  id    = "${data.aws_subnet_ids.private.ids[count.index]}"
}