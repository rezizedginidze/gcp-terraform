# google_client_config and kubernetes provider must be explicitly specified like the following.

data "google_client_config" "default" {}
# [START artifactregistry_docker_repo]
resource "google_artifact_registry_repository" "main" {
  location      = "us"
  repository_id = "main"
  format        = "DOCKER"
  project       = var.project_id
}
resource "google_artifact_registry_repository_iam_binding" "binding" {
  provider   = google-beta
  project    = google_artifact_registry_repository.main.project
  location   = google_artifact_registry_repository.main.location
  repository = google_artifact_registry_repository.main.name
  role       = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${module.gke-db1.service_account}",
  ]
}
# [END artifactregistry_docker_repo]

module "network" {
  source     = "../modules/network"
  project_id = var.project_id
}
# [START gke_standard_private_regional_primary_cluster]
module "gke-db1" {
  source                   = "../modules/beta-private-cluster"
  project_id               = var.project_id
  name                     = "db1"
  regional                 = true
  region                   = "us-central1"
  network                  = module.network.network_name
  subnetwork               = module.network.primary_subnet_name
  ip_range_pods            = "ip-range-pods-db1"
  ip_range_services        = "ip-range-svc-db1"
  create_service_account   = true
  enable_private_endpoint  = false
  enable_private_nodes     = true
  master_ipv4_cidr_block   = "172.16.0.0/28"
  network_policy           = true
  cluster_autoscaling = {
    "autoscaling_profile": "OPTIMIZE_UTILIZATION",
    "enabled" : true,
    "gpu_resources" : [],
    "min_cpu_cores" : 36,
    "min_memory_gb" : 144,
    "max_cpu_cores" : 48,
    "max_memory_gb" : 192,
  }
  monitoring_enable_managed_prometheus = true
  gke_backup_agent_config = true

  node_pools = [
    {
      name            = "pool-sys"
      autoscaling     = true
      min_count       = 1
      max_count       = 3
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-4"
      node_locations  = "us-central1-a,us-central1-b,us-central1-c"
      auto_repair     = true
    },
    {
      name            = "pool-db"
      autoscaling     = true
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-8"
      node_locations  = "us-central1-a,us-central1-b,us-central1-c"
      auto_repair     = true
    },
  ]
  node_pools_labels = {
    all = {}
    pool-db = {
      "app.stateful/component" = "postgresql"
    }
    pool-sys = {
      "app.stateful/component" = "postgresql-pgpool"
    }
  }
  node_pools_taints = {
    all = []
    pool-db = [
      {
        key    = "app.stateful/component"
        value  = "postgresql"
        effect = "NO_SCHEDULE"
      },
    ],
    pool-sys = [
      {
        key    = "app.stateful/component"
        value  = "postgresql-pgpool"
        effect = "NO_SCHEDULE"
      },
    ],
  }
  gce_pd_csi_driver = true
}
# [END gke_standard_private_regional_primary_cluster]
# [START gke_standard_private_regional_backup_cluster]
module "gke-db2" {
  source                   = "../modules/beta-private-cluster"
  project_id               = var.project_id
  name                     = "db2"
  regional                 = true
  region                   = "us-west1"
  network                  = module.network.network_name
  subnetwork               = module.network.secondary_subnet_name
  ip_range_pods            = "ip-range-pods-db2"
  ip_range_services        = "ip-range-svc-db2"
  create_service_account   = false
  service_account          = module.gke-db1.service_account
  enable_private_endpoint  = false
  enable_private_nodes     = true
  master_ipv4_cidr_block   = "172.16.0.16/28"
  network_policy           = true
  cluster_autoscaling = {
    "autoscaling_profile": "OPTIMIZE_UTILIZATION",
    "enabled" : true,
    "gpu_resources" : [],
    "min_cpu_cores" : 10,
    "min_memory_gb" : 144,
    "max_cpu_cores" : 48,
    "max_memory_gb" : 192,
  }
  monitoring_enable_managed_prometheus = true
  gke_backup_agent_config = true
  node_pools = [
    {
      name            = "pool-sys"
      autoscaling     = true
      min_count       = 1
      max_count       = 3
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-4"
      node_locations  = "us-west1-a,us-west1-b,us-west1-c"
      auto_repair     = true
    },
    {
      name            = "pool-db"
      autoscaling     = true
      max_surge       = 1
      max_unavailable = 0
      machine_type    = "e2-standard-8"
      node_locations  = "us-west1-a,us-west1-b,us-west1-c"
      auto_repair     = true
    },
  ]
  node_pools_labels = {
    all = {}
    pool-db = {
      "app.stateful/component" = "postgresql"
    }
    pool-sys = {
      "app.stateful/component" = "postgresql-pgpool"
    }
  }
  node_pools_taints = {
    all = []
    pool-db = [
      {
        key    = "app.stateful/component"
        value  = "postgresql"
        effect = "NO_SCHEDULE"
      },
    ],
    pool-sys = [
      {
        key    = "app.stateful/component"
        value  = "postgresql-pgpool"
        effect = "NO_SCHEDULE"
      },
    ],
  }
  gce_pd_csi_driver = true
}
# [END gke_standard_private_regional_backup_cluster]