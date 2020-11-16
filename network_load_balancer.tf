resource "aws_lb" "loadbalancer" {
    arn                              = "Will be known after deployment"
    arn_suffix                       = "Will be known after deployment - this is the part from above after ~~~670824338614:loadbalancer~~~"
    dns_name                         = "Will be known after deployment: e.g. api-9-LoadB-RCE24E8FTK2A-e40102e887d0e5ae.elb.eu-west-2.amazonaws.com"
    enable_cross_zone_load_balancing = false
    enable_deletion_protection       = false
    id                               = "Will be known after deployment: equals arn"
    internal                         = true
    ip_address_type                  = "ipv4"
    load_balancer_type               = "network"
    name                             = "api-9-LoadB-RCE24E8FTK2A"
    security_groups                  = []
    subnets                          = [
        "${data.aws_subnet_ids.private.ids[0]}",
        "${data.aws_subnet_ids.private.ids[1]}",
        "${data.aws_subnet_ids.private.ids[2]}"
    ]
    tags = {
      Application                    = ""
      Environment                    = "${var.environment}"
      CostCode                       = ""
      SquadName                      = ""
    }
    vpc_id                           = "${data.aws_vpcs.vpc.ids[0]}"
    zone_id                          = ""

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

