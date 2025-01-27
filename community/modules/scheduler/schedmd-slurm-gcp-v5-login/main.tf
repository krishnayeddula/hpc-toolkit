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

locals {
  ghpc_startup_script = [{
    filename = "ghpc_startup.sh"
    content  = var.startup_script
  }]
  # Since deployment name may be used to create a cluster name, we remove any invalid character from the beginning
  # Also, slurm imposed a lot of restrictions to this name, so we format it to an acceptable string
  tmp_cluster_name   = substr(replace(lower(var.deployment_name), "/^[^a-z]*|[^a-z0-9]/", ""), 0, 10)
  slurm_cluster_name = var.slurm_cluster_name != null ? var.slurm_cluster_name : local.tmp_cluster_name

  enable_public_ip_access_config = var.disable_login_public_ips ? [] : [{ nat_ip = null, network_tier = null }]
  access_config                  = length(var.access_config) == 0 ? local.enable_public_ip_access_config : var.access_config
}

module "slurm_login_template" {
  source = "github.com/SchedMD/slurm-gcp.git//terraform/slurm_cluster/modules/slurm_instance_template?ref=v5.1.0"

  additional_disks         = var.additional_disks
  bandwidth_tier           = "platform_default"
  can_ip_forward           = var.can_ip_forward
  slurm_cluster_name       = local.slurm_cluster_name
  disable_smt              = var.disable_smt
  disk_auto_delete         = var.disk_auto_delete
  disk_labels              = var.labels
  disk_size_gb             = var.disk_size_gb
  disk_type                = var.disk_type
  enable_confidential_vm   = var.enable_confidential_vm
  enable_oslogin           = var.enable_oslogin
  enable_shielded_vm       = var.enable_shielded_vm
  gpu                      = var.gpu
  labels                   = var.labels
  machine_type             = var.machine_type
  metadata                 = var.metadata
  min_cpu_platform         = var.min_cpu_platform
  network_ip               = var.network_ip != null ? var.network_ip : ""
  on_host_maintenance      = var.on_host_maintenance
  preemptible              = var.preemptible
  project_id               = var.project_id
  region                   = var.region
  service_account          = var.service_account
  shielded_instance_config = var.shielded_instance_config
  slurm_instance_role      = "login"
  source_image_family      = var.source_image_family
  source_image_project     = var.source_image_project
  source_image             = var.source_image
  network                  = var.network_self_link == null ? "" : var.network_self_link
  subnetwork_project       = var.subnetwork_project == null ? "" : var.subnetwork_project
  subnetwork               = var.subnetwork_self_link == null ? "" : var.subnetwork_self_link
  tags                     = concat([local.slurm_cluster_name], var.tags)
}

module "slurm_login_instance" {
  source = "github.com/SchedMD/slurm-gcp.git//terraform/slurm_cluster/modules/slurm_login_instance?ref=v5.1.0"

  access_config         = local.access_config
  slurm_cluster_name    = local.slurm_cluster_name
  instance_template     = module.slurm_login_template.self_link
  network               = var.network_self_link
  num_instances         = var.num_instances
  project_id            = var.project_id
  region                = var.region
  static_ips            = var.static_ips
  subnetwork_project    = var.subnetwork_project
  subnetwork            = var.subnetwork_self_link
  zone                  = var.zone
  login_startup_scripts = local.ghpc_startup_script

  metadata = merge({
    slurm_depends_on_controller = sha256(var.controller_instance_id)
  }, var.metadata)
}
