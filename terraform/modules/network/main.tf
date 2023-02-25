// [START vpc_multi_region_network]
module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = "< 7.0.0"

  project_id   = var.project_id
  network_name = "vpc-postgres"

  subnets = [
    {
      subnet_name           = "snet-gke-postgresql-us-central1"
      subnet_ip             = "10.0.0.0/17"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "snet-gke-postgresql-us-west1"
      subnet_ip             = "10.0.128.0/17"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    ("snet-gke-postgresql-us-central1") = [
      {
        range_name    = "ip-range-pods-db1"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "ip-range-svc-db1"
        ip_cidr_range = "192.168.64.0/18"
      },
    ],
    ("snet-gke-postgresql-us-west1") = [
      {
        range_name    = "ip-range-pods-db2"
        ip_cidr_range = "192.168.128.0/18"
      },
      {
        range_name    = "ip-range-svc-db2"
        ip_cidr_range = "192.168.192.0/18"
      },
    ]
  }
}

output "network_name" {
  value = module.gcp-network.network_name
}

output "primary_subnet_name" {
  value = module.gcp-network.subnets_names[0]
}

output "secondary_subnet_name" {
  value = module.gcp-network.subnets_names[1]
}
// [END vpc_multi_region_network]