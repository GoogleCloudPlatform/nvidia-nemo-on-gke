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

output "resource_self_link" {
  description = "The self_link of the resource policy created."
  value = one(concat(
    resource.google_compute_resource_policy.new_placement_policy[*].self_link,
    data.google_compute_resource_policy.existing_placement_policy[*].self_link,
  ))
}

output "resource_name" {
  description = "The self_link of the resource policy created."
  value = one(concat(
    resource.google_compute_resource_policy.new_placement_policy[*].name,
    data.google_compute_resource_policy.existing_placement_policy[*].name,
  ))
}
