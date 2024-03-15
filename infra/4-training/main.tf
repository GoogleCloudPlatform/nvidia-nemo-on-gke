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
    path = "../3-config/terraform.tfstate"
  }
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {
  current_timestamp  = timestamp()
  formatted_datetime = formatdate("YYYYMMDDHHmmss", timestamp())
}

resource "helm_release" "nemo_example" {
  name  = "${var.user}-nemo-gpt-5b-${local.formatted_datetime}"
  chart = "./nemo-example/"

  set {
    name  = "workload.image"
    value = var.training_image_name
  }

  set {
    name  = "workload.gpus"
    value = data.terraform_remote_state.a3-gke.outputs.gpu_count
  }
  set {
    name  = "queue"
    value = var.kueue_name
  }
}
