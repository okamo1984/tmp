terraform {
  required_version = ">= 1.0.0"

  required_providers {
    ec = {
      source  = "elastic/ec"
      version = "0.7.0"
    }
  }
}

module "elastic" {
  source                = "./modules/elastic"
  gcp_psc_connection_id = var.gcp_psc_connection_id
}
