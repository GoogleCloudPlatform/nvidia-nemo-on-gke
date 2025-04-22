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

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "project_reuse" {
  description = "Reuse existing project if not null. If name and number are not passed in, a data source is used."
  type = object({
    use_data_source = optional(bool, true)
    project_attributes = optional(object({
      name             = string
      number           = number
      services_enabled = optional(list(string), [])
    }))
  })
  default = null
  validation {
    condition = (
      try(var.project_reuse.use_data_source, null) != false ||
      try(var.project_reuse.project_attributes, null) != null
    )
    error_message = "Reuse datasource can be disabled only if project attributes are set."
  }
}

variable "tf_state_bucket" {
  description = "The parameters of the bucket to be used by automation tools including Terraform backend"
  type = object({
    name     = string
    location = string
  })
}

variable "services" {
  description = "Additional services to enable"
  type        = list(string)
  default     = ["container.googleapis.com"]
  nullable    = false
}

variable "deletion_protection" {
  description = " If this field is set, Terraform operations like destroy or apply that would delete these resources will fail."
  type        = bool
  default     = true
  nullable    = false
}