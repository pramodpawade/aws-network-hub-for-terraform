/* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
   SPDX-License-Identifier: MIT-0 */

locals {
  config = var.env_config[var.environment]
}

locals {
  tags = {
    Product    = "Network_Automation"
    Owner      = "WWPS"
    Project_ID = "12345"
    Env        = var.environment
  }

  availability_zone_names = data.aws_availability_zones.available.names
  endpoints             = { for e in var.vpc_endpoints : "com.amazonaws.${var.aws_region}.${e}" => "${e}.${var.aws_region}.amazonaws.com" }
  centralised_endpoints = { for e in var.centralised_vpc_endpoints : e => "${e}.${var.aws_region}.amazonaws.com" }
  tgw_map               = { for e in local.config.tgw_route_tables : "name_${e}" => "${e}" }
  tgw_route_table       = { for i in sort(keys(local.tgw_map)) : i => data.aws_ec2_transit_gateway_route_table.org_env[i].id }
}
