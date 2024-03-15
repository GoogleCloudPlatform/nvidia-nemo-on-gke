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

variable "zone" {
  type        = string
  description = "GCP zone within a region where resources will be deployed"
  nullable    = true
}

variable "is_zonal" {
  type        = bool
  description = "FLag to determine if the cluster will be a zonal or regiona"
  nullable    = false
  default     = true
}

variable "cluster_prefix" {
  type        = string
  description = "GKE Cluster name / prefix"
  nullable    = false
  default     = "gke-demo-2024-1"
}

variable "gke_version" {
  type        = string
  description = "GKE version"
  nullable    = false
  default     = "1.27.8-gke.1067004"
}

variable "nodepool_default_count" {
  type        = number
  description = "Number of nodes for default node pool"
  nullable    = false
  default     = 1
}

variable "nodepool_default_type" {
  type        = string
  description = "Instance type for default node pool"
  nullable    = false
  default     = "e2-medium-2"
}

variable "node_count" {
  type        = number
  description = "Number of GPU nodes in Node pool"
  nullable    = false
  default     = 1
}

variable "node_type" {
  type        = string
  description = "Instance type"
  nullable    = false
  default     = "a3-highgpu-8g"
}

