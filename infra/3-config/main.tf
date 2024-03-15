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

data "terraform_remote_state" "a3-gke" {
  backend = "local"

  config = {
    path = "../2-setup/terraform.tfstate"
  }
}

resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials ${data.terraform_remote_state.a3-gke.outputs.cluster_prefix} \
        --region ${data.terraform_remote_state.a3-gke.outputs.cluster_location}

    EOT
  }
  depends_on = [data.terraform_remote_state.a3-gke]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "null_resource" "install_kueue" {
  provisioner "local-exec" {
    command = <<EOT
    curl -Lo ./manifests/jobmgmt/kueue_${var.kueue_version}.yaml https://github.com/kubernetes-sigs/kueue/releases/download/${var.kueue_version}/manifests.yaml && \
    kubectl apply --server-side -f ./manifests/jobmgmt/kueue_${var.kueue_version}.yaml
    EOT
  }
  depends_on = [null_resource.kubectl_config]
  
}

resource "time_sleep" "kueue_init_complete" {
  depends_on = [null_resource.install_kueue]

  create_duration = "30s"
}

resource "null_resource" "config_kueue_resource" {
  provisioner "local-exec" {
    command = <<EOT
    sed -e 's/GPU_COUNT/${data.terraform_remote_state.a3-gke.outputs.gpu_count}/g' \
    -e 's/CLUSTER_QUEUE_NAME/${var.kueue_cluster_name}/g' \
    -e 's/LOCAL_QUEUE_NAME/${var.kueue_local_name}/g' \
    ./manifests/jobmgmt/kueue-all.yaml | kubectl apply -f - 
    EOT
  }
  depends_on = [time_sleep.kueue_init_complete]
}

resource "kubernetes_manifest" "storageclass" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/storage/storage-class-filestore.yaml.tpl",
      {
        TIER = var.storage_tier,
        PREFIX = data.terraform_remote_state.a3-gke.outputs.cluster_prefix
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "pvc" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/storage/pvc-filestore.yaml.tpl",
      {
        NFS_SIZE = var.storage_size
    })
  )
  depends_on = [kubernetes_manifest.storageclass]
}

resource "kubernetes_manifest" "network_vpc_1" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-network.yaml.tpl",
      {
        GKE_NETWORK_NAME = "vpc1",
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "network_vpc_2" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-network.yaml.tpl",
      {
        GKE_NETWORK_NAME = "vpc2",
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "network_vpc_3" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-network.yaml.tpl",
      {
        GKE_NETWORK_NAME = "vpc3",
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "network_vpc_4" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-network.yaml.tpl",
      {
        GKE_NETWORK_NAME = "vpc4",
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "gke_network_1" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-gke.yaml.tpl",
      {
        GKE_NETWORK_NAME    = "vpc1",
        CLUSTER_VPC_NETWORK = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-0",
        CLUSTER_VPC_SUBNET  = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-0"
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "gke_network_2" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-gke.yaml.tpl",
      {
        GKE_NETWORK_NAME    = "vpc2",
        CLUSTER_VPC_NETWORK = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-1",
        CLUSTER_VPC_SUBNET  = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-1"
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "gke_network_3" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-gke.yaml.tpl",
      {
        GKE_NETWORK_NAME    = "vpc3",
        CLUSTER_VPC_NETWORK = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-2",
        CLUSTER_VPC_SUBNET  = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-2"
    })
  )
  depends_on = [null_resource.kubectl_config]
}
resource "kubernetes_manifest" "gke_network_4" {
  manifest = yamldecode(
    templatefile("${path.module}/manifests/network/pass-through-gke.yaml.tpl",
      {
        GKE_NETWORK_NAME    = "vpc4",
        CLUSTER_VPC_NETWORK = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-3",
        CLUSTER_VPC_SUBNET  = "${data.terraform_remote_state.a3-gke.outputs.cluster_prefix}-gpu-3"
    })
  )
  depends_on = [null_resource.kubectl_config]
}

#TODO: Convert to TF instead of CLI
resource "null_resource" "tensorboard-invproxy-security" {
  provisioner "local-exec" {
    command = <<EOT
    DEFAULT_SERVICEACCOUNT=$(gcloud iam service-accounts list --format="table[no-heading](name)" --filter "displayName='Compute Engine default service account'") && \
    echo "Found default service account $DEFAULT_SERVICEACCOUNT" && \
    DEFAULT_SERVICEACCOUNT=$(basename $DEFAULT_SERVICEACCOUNT) && \
    echo "Adding role to service account $DEFAULT_SERVICEACCOUNT" && \
    gcloud iam service-accounts add-iam-policy-binding $DEFAULT_SERVICEACCOUNT \
        --role roles/iam.workloadIdentityUser \
        --member "serviceAccount:${data.terraform_remote_state.a3-gke.outputs.project_id}.svc.id.goog[default/default]" &&
    kubectl annotate serviceaccount default \
        --namespace default --overwrite \
        iam.gke.io/gcp-service-account=$DEFAULT_SERVICEACCOUNT
    EOT
  }
  depends_on = [data.terraform_remote_state.a3-gke]
}

#TODO: Convert to TF instead of CLI
resource "null_resource" "install_tensorboard_invproxy" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply --server-side -f ./manifests/tensorboard/tensorboard.yaml
    EOT
  }
  depends_on = [null_resource.kubectl_config]
}
