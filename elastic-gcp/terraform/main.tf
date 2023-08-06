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
  version    = "latest"
  region     = "gcp-asia-northeast1"
}
