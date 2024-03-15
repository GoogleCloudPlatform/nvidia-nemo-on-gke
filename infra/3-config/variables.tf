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
 
variable "kueue_version" {
  type        = string
  description = "Kueue version"
  nullable    = false
  default     = "v0.5.2"
}

variable "kueue_cluster_name" {
  type        = string
  description = "The name of Kueue Cluster queue"
  nullable    = false
  default     = "a3-queue"
}

variable "kueue_local_name" {
  type        = string
  description = "The name of Kueue Local queue"
  nullable    = false
  default     = "a3-queue"
}

variable "storage_tier" {
  type        = string
  description = "Tier of Cloud Filestore [BASIC_HDD,BASIC_SSD,ENTERPRISE]"
  nullable    = false
  default     = "BASIC_HDD"
}

variable "storage_size" {
  type        = string
  description = "Size of Cloud Filestore"
  nullable    = false
  default     = "1Ti"
}
