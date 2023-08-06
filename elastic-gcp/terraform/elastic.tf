# Elastic
provider "ec" {}

data "ec_stack" "latest" {
  version_regex = local.version
  region        = local.region
}

resource "ec_deployment" "evaluation_trial" {
  name = "evaluation-trial"

  region  = local.region
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

  kibana = {}

  integrations_server = {}

  enterprise_search = {}
}

resource "ec_deployment_traffic_filter" "gcp_psc" {
  name   = "psc-elastic-cloud"
  region = local.region
  type   = "gcp_private_service_connect_endpoint"

  rule {
    source = var.gcp_psc_connection_id
  }
}
