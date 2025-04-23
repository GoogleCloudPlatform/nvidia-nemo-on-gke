/*
 Copyright 2024 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

data "terraform_remote_state" "bootstrap" {
  backend = "local"

  config = {
    path = "../1-bootstrap/terraform.tfstate"
  }
}

data "google_project" "current" {
  project_id = data.terraform_remote_state.bootstrap.outputs.project_id
}

locals {
  project_id = data.google_project.current.project_id
  region     = data.terraform_remote_state.bootstrap.outputs.region
  zone       = data.terraform_remote_state.bootstrap.outputs.zone
  location   = data.terraform_remote_state.bootstrap.outputs.location
  }

module "a3-gke" {
  source = "../terraform/modules/a3/cluster/gke"

  project_id = local.project_id
  region     = local.region
  zone       = local.zone

  resource_prefix      = var.cluster_prefix
  gke_version          = var.gke_version
  enable_gke_dashboard = true

  node_pools = [
    {
      zone         = var.is_zonal == true ? local.zone : local.region
      machine_type = var.node_type
      node_count   = var.node_count
    }
  ]

  default_node_pool = {
    zone         = var.is_zonal == true ? local.zone : local.region
    machine_type = var.nodepool_default_type
    node_count   = var.nodepool_default_count
  }
}

resource "google_artifact_registry_repository" "artifactreg-repo" {
  project       = local.project_id
  location      = local.region
  repository_id = var.cluster_prefix
  description   = "${var.cluster_prefix} docker repository"
  format        = "DOCKER"
}

resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials ${module.a3-gke.name} \
        --region ${module.a3-gke.location}

    EOT
  }
  depends_on = [module.a3-gke]
}
