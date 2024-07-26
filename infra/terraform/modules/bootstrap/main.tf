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

locals {
  gcs_storage_class = (
    length(split("-", var.tf_state_bucket.location)) < 2
    ? "MULTI_REGIONAL"
    : "REGIONAL"
  )

  default_services = [
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "stackdriver.googleapis.com",
    "storage.googleapis.com",
  ]
  services = concat(local.default_services, var.services)
}

module "project_config" {
  source         = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v32.0.1&depth=1"
  name           = var.project_id
  project_create = false
  services       = local.services
}

module "tf_state_backend" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gcs?ref=v32.0.1&depth=1"
  project_id    = module.project_config.project_id
  name          = var.tf_state_bucket.name
  location      = var.tf_state_bucket.location
  storage_class = local.gcs_storage_class
  versioning    = true
  force_destroy = var.deletion_protection ? false : true
}

