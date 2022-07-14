/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "block_metadata_server" {
  description = "Use Linux firewall to block the instance metadata server for users other than root and HTCondor daemons"
  type        = bool
  default     = true
}

variable "enable_docker" {
  description = "Install and enable docker daemon alongside HTCondor"
  type        = bool
  default     = true
}
