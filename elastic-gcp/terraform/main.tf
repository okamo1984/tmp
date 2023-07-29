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
  region  = "asia-northeast-1"
}

resource "ec_deployment" "evaluation_trial" {
  name = "evaluation-trial"

  region  = local.region
  version = local.version

  traffic_filter = [
    ec_deployment_traffic_filter.gcp_psc.id
  ]

  elasticsearch = {}

  kibana = {}

  integrations_server = {}

  enterprise_search = {}
}

resource "ec_deployment_traffic_filter" "gcp_psc" {
  name   = "psc-elastic-cloud"
  region = local.region
  type   = "gcp_private_service_connect_endpoint"

  rule {
    source = var.gcp_vcp_endpoint_id
  }
}
