module "elastic" {
  source                 = "./modules/elastic"
  gcp_psc_connection_id  = module.gcp.psc_connection_id
  region                 = "gcp-asia-northeast1"
  traffic_filter_ip_cidr = var.es_traffic_filter_ip_cidr
}

module "gcp" {
  source     = "./modules/gcp"
  project_id = var.gcp_project_id
  region     = "asia-northeast1"
}

variable "gcp_project_id" {
  type        = string
  description = "Google Cloud Platform project id (not name)"
}

variable "es_traffic_filter_ip_cidr" {
  type        = string
  description = "IP CIDR used by Elastic Cloud traffic filter"
}
