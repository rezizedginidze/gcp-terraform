


terraform {
  required_version = ">=0.13"

  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.42.0, < 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-kubernetes-engine:beta-private-cluster/v24.0.0"
  }
}
