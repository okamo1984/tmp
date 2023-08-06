terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.7.0"
    }
  }
}

locals {
  version = "latest"
}

data "ec_stack" "latest" {
  version_regex = local.version
  region        = var.region
}

resource "ec_deployment" "evaluation_trial" {
  # If not specified, detect `ec` as hashicorp/es
  provider = ec
  name     = "evaluation-trial"

  region  = var.region
  version = data.ec_stack.latest.version

  traffic_filter = [
    ec_deployment_traffic_filter.gcp_psc.id
  ]

  deployment_template_id = "gcp-compute-optimized"

  elasticsearch = {
    hot = {
      autoscaling = {
        max_size          = "1g"
        max_size_resource = "memory"
      }
      zone_count    = 1
      size          = "1g"
      size_resource = "memory"
    }
  }

  kibana = {
    size = "1g"
    size_resource = "memory"
    zone_count = 1
  }

  integrations_server = {}

  enterprise_search = {
    size          = "2g"
    size_resource = "memory"
    zone_count    = 1
  }
}

resource "ec_deployment_traffic_filter" "gcp_psc" {
  provider = ec
  name     = "psc-elastic-cloud"
  region   = var.region
  type     = "gcp_private_service_connect_endpoint"

  rule {
    source = var.gcp_psc_connection_id
  }
}
