terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.76.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.76.0"
    }
  }
}

locals {
  project_id     = var.project_id
  region         = "asia-northeast1"
  psc_ip_address = "10.1.0.2"
}

provider "google" {
  project = local.project_id
  region  = local.region
}

provider "google-beta" {
  project = local.project_id
  region  = local.region
}

resource "google_compute_network" "vpc_elastic" {
  name                    = "vpc-elastic"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_elastic_sub" {
  name                     = "vpc-elastic-sub"
  ip_cidr_range            = "10.1.0.0/16"
  network                  = google_compute_network.vpc_elastic.id
  private_ip_google_access = true
}

resource "google_compute_address" "psc_elastic" {
  name         = "psc-elastic-ip"
  address_type = "INTERNAL"
  subnetwork   = google_compute_subnetwork.vpc_elastic_sub.id
  address      = local.psc_ip_address
}

resource "google_compute_forwarding_rule" "gcp_elastic_rule" {
  name                    = "gcpelastic"
  load_balancing_scheme   = ""
  target                  = "projects/cloud-production-168820/regions/asia-northeast1/serviceAttachments/proxy-psc-production-asia-northeast1-v1-attachment"
  network                 = google_compute_network.vpc_elastic.name
  ip_address              = google_compute_address.psc_elastic.id
  allow_psc_global_access = true
  service_directory_registrations {
    namespace = "elastic"
  }
}

resource "google_dns_managed_zone" "psc_elastic" {
  name        = "psc-elastic"
  dns_name    = "psc.${local.region}.gcp.cloud.es.io."
  description = "DNS zone for PSC to Elastic Cloud"
  visibility  = "private"
}

resource "google_dns_record_set" "psc" {
  name = "*.${google_dns_managed_zone.psc_elastic.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.psc_elastic.name

  rrdatas = [local.psc_ip_address]
}
