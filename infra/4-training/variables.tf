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

variable "user" {
  type        = string
  description = "User Environment variable"
  nullable    = false
}

variable "training_image_name" {
  type        = string
  description = "NVIDIA NeMo Training Framework image URL"
  nullable    = false
  default     = "nvcr.io/nvidia/nemo:23.06"
}

variable "kueue_name" {
  type        = string
  description = "Kueue Local queue name"
  nullable    = true
}
