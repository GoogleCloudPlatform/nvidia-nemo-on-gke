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

output "cluster_prefix" {
  description = "GKE Cluster name"
  value       = module.a3-gke.name
}

output "cluster_location" {
  description = "GKE Cluster location"
  value       = module.a3-gke.location
}

output "project_id" {
  description = "Project ID"
  value       = data.google_project.current.project_id
}

output "gpu_count" {
  description = "Number of GPUs in Cluster. Each node has 8 GPUs"
  value       = var.node_count * 8
}
