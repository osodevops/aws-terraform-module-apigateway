resource "aws_lb" "loadbalancer" {
    enable_cross_zone_load_balancing = false
    enable_deletion_protection       = false
    internal                         = true
    ip_address_type                  = "ipv4"
    load_balancer_type               = "network"
    name                             = "api64-Loadbalancer"
    security_groups                  = []
    subnets                          = [
        "${data.aws_subnet_ids.private.ids[0]}",
        "${data.aws_subnet_ids.private.ids[1]}",
        "${data.aws_subnet_ids.private.ids[2]}"
    ]
    tags = {
      Application                    = "${var.application}"
      Environment                    = "${var.environment}"
      CostCode                       = "${var.costcode}"
      SquadName                      = "${var.squadname}"
    }
    vpc_id                           = "${data.aws_vpcs.vpc.ids[0]}"
    zone_id                          = "Z00336371X2ZSQKFAL697"

    access_logs {
        enabled = false
    }

    subnet_mapping {
        subnet_id = "${data.aws_subnet_ids.private.ids[0]}"
    }
    subnet_mapping {
        subnet_id = "${data.aws_subnet_ids.private.ids[1]}"
    }
    subnet_mapping {
        subnet_id = "${data.aws_subnet_ids.private.ids[2]}"
    }

    timeouts {}
}

