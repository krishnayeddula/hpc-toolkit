## Description

This module creates a login node for a Slurm cluster based on the
[SchedMD/slurm-gcp] [slurm\_instance\_template] and [slurm\_login\_instance]
terraform modules. The login node is used in conjunction with the
[Slurm controller](../schedmd-slurm-gcp-v5-controller/README.md).

[SchedMD/slurm-gcp]: https://github.com/SchedMD/slurm-gcp/tree/v5.0.2
[slurm\_login\_instance]: https://github.com/SchedMD/slurm-gcp/tree/v5.0.2/terraform/slurm_cluster/modules/slurm_login_instance
[slurm\_instance\_template]: https://github.com/SchedMD/slurm-gcp/tree/v5.0.2/terraform/slurm_cluster/modules/slurm_instance_template

### Example

```yaml
- id: slurm_login
  source: community/modules/scheduler/schedmd-slurm-gcp-v5-login
  kind: terraform
  use:
  - network1
  - slurm_controller
  - homefs
  settings:
    machine_type: n2-standard-4
```

This creates a Slurm login node which is:

* connected to the primary subnet of network1 via `use`
* mounted to the homefs filesystem via `use`
* associated with the `slurm_controller` module as the slurm controller via
  `use`
* of VM machine type `n2-standard-4`

For a complete example using this module, see
[slurm-gcp-v5-cluster.yaml](../../../examples/slurm-gcp-v5-cluster.yaml).

## Support
The HPC Toolkit team maintains the wrapper around the [slurm-on-gcp] terraform
modules. For support with the underlying modules, see the instructions in the
[slurm-gcp README][slurm-gcp-readme].

[slurm-on-gcp]: https://github.com/SchedMD/slurm-gcp/tree/v5.0.2
[slurm-gcp-readme]: https://github.com/SchedMD/slurm-gcp/tree/v5.0.2#slurm-on-google-cloud-platform

## License
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_slurm_login_instance"></a> [slurm\_login\_instance](#module\_slurm\_login\_instance) | github.com/SchedMD/slurm-gcp.git//terraform/slurm_cluster/modules/slurm_login_instance | v5.1.0 |
| <a name="module_slurm_login_template"></a> [slurm\_login\_template](#module\_slurm\_login\_template) | github.com/SchedMD/slurm-gcp.git//terraform/slurm_cluster/modules/slurm_instance_template | v5.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_config"></a> [access\_config](#input\_access\_config) | Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet. | <pre>list(object({<br>    nat_ip       = string<br>    network_tier = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_disks"></a> [additional\_disks](#input\_additional\_disks) | List of maps of disks. | <pre>list(object({<br>    disk_name    = string<br>    device_name  = string<br>    disk_type    = string<br>    disk_size_gb = number<br>    disk_labels  = map(string)<br>    auto_delete  = bool<br>    boot         = bool<br>  }))</pre> | `[]` | no |
| <a name="input_can_ip_forward"></a> [can\_ip\_forward](#input\_can\_ip\_forward) | Enable IP forwarding, for NAT instances for example. | `bool` | `false` | no |
| <a name="input_controller_instance_id"></a> [controller\_instance\_id](#input\_controller\_instance\_id) | The server-assigned unique identifier of the controller instance, typically<br>supplied as an output of the controler module. | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | Name of the deployment. | `string` | n/a | yes |
| <a name="input_disable_login_public_ips"></a> [disable\_login\_public\_ips](#input\_disable\_login\_public\_ips) | If set to false. The login will have a random public IP assigned to it. Ignored if access\_config is set. | `bool` | `true` | no |
| <a name="input_disable_smt"></a> [disable\_smt](#input\_disable\_smt) | Disables Simultaneous Multi-Threading (SMT) on instance. | `bool` | `false` | no |
| <a name="input_disk_auto_delete"></a> [disk\_auto\_delete](#input\_disk\_auto\_delete) | Whether or not the boot disk should be auto-deleted. | `bool` | `true` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Boot disk size in GB. | `number` | `50` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Boot disk type, can be either pd-ssd, local-ssd, or pd-standard. | `string` | `"pd-standard"` | no |
| <a name="input_enable_confidential_vm"></a> [enable\_confidential\_vm](#input\_enable\_confidential\_vm) | Enable the Confidential VM configuration. Note: the instance image must support option. | `bool` | `false` | no |
| <a name="input_enable_oslogin"></a> [enable\_oslogin](#input\_enable\_oslogin) | Enables Google Cloud os-login for user login and authentication for VMs.<br>See https://cloud.google.com/compute/docs/oslogin | `bool` | `true` | no |
| <a name="input_enable_shielded_vm"></a> [enable\_shielded\_vm](#input\_enable\_shielded\_vm) | Enable the Shielded VM configuration. Note: the instance image must support option. | `bool` | `false` | no |
| <a name="input_gpu"></a> [gpu](#input\_gpu) | GPU information. Type and count of GPU to attach to the instance template. See<br>https://cloud.google.com/compute/docs/gpus more details.<br>* type : the GPU type<br>* count : number of GPUs | <pre>object({<br>    type  = string<br>    count = number<br>  })</pre> | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels, provided as a map. | `map(string)` | `{}` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type to create. | `string` | `"n2-standard-2"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Metadata, provided as a map. | `map(string)` | `{}` | no |
| <a name="input_min_cpu_platform"></a> [min\_cpu\_platform](#input\_min\_cpu\_platform) | Specifies a minimum CPU platform. Applicable values are the friendly names of<br>CPU platforms, such as Intel Haswell or Intel Skylake. See the complete list:<br>https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform | `string` | `null` | no |
| <a name="input_network_ip"></a> [network\_ip](#input\_network\_ip) | Private IP address to assign to the instance if desired. | `string` | `""` | no |
| <a name="input_network_self_link"></a> [network\_self\_link](#input\_network\_self\_link) | Network to deploy to. Either network\_self\_link or subnetwork\_self\_link must be specified. | `string` | `null` | no |
| <a name="input_num_instances"></a> [num\_instances](#input\_num\_instances) | Number of instances to create. This value is ignored if static\_ips is provided. | `number` | `1` | no |
| <a name="input_on_host_maintenance"></a> [on\_host\_maintenance](#input\_on\_host\_maintenance) | Instance availability Policy. | `string` | `"MIGRATE"` | no |
| <a name="input_preemptible"></a> [preemptible](#input\_preemptible) | Allow the instance to be preempted. | `bool` | `false` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID to create resources in. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the instances should be created.<br>Note: region will be ignored if it can be extracted from subnetwork. | `string` | `null` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service account to attach to the instances. See<br>'main.tf:local.service\_account' for the default. | <pre>object({<br>    email  = string<br>    scopes = set(string)<br>  })</pre> | `null` | no |
| <a name="input_shielded_instance_config"></a> [shielded\_instance\_config](#input\_shielded\_instance\_config) | Shielded VM configuration for the instance. Note: not used unless<br>enable\_shielded\_vm is 'true'.<br>* enable\_integrity\_monitoring : Compare the most recent boot measurements to the<br>  integrity policy baseline and return a pair of pass/fail results depending on<br>  whether they match or not.<br>* enable\_secure\_boot : Verify the digital signature of all boot components, and<br>  halt the boot process if signature verification fails.<br>* enable\_vtpm : Use a virtualized trusted platform module, which is a<br>  specialized computer chip you can use to encrypt objects like keys and<br>  certificates. | <pre>object({<br>    enable_integrity_monitoring = bool<br>    enable_secure_boot          = bool<br>    enable_vtpm                 = bool<br>  })</pre> | <pre>{<br>  "enable_integrity_monitoring": true,<br>  "enable_secure_boot": true,<br>  "enable_vtpm": true<br>}</pre> | no |
| <a name="input_slurm_cluster_name"></a> [slurm\_cluster\_name](#input\_slurm\_cluster\_name) | Cluster name, used for resource naming and slurm accounting. If not provided it will default to the first 8 characters of the deployment name (removing any invalid characters). | `string` | `null` | no |
| <a name="input_source_image"></a> [source\_image](#input\_source\_image) | Source disk image. By default, the image used will be the hpc-centos7<br>version of the slurm-gcp public images. More information can be found in the<br>slurm-gcp docs:<br>https://github.com/SchedMD/slurm-gcp/blob/v5.0.2/docs/images.md#public-image | `string` | `null` | no |
| <a name="input_source_image_family"></a> [source\_image\_family](#input\_source\_image\_family) | Source image family. If not provided, the default image family name for the<br>hpc-centos-7 version of the slurm-gcp public images will be used. More<br>information can be found in the slurm-gcp docs:<br>https://github.com/SchedMD/slurm-gcp/blob/v5.0.2/docs/images.md#public-image | `string` | `null` | no |
| <a name="input_source_image_project"></a> [source\_image\_project](#input\_source\_image\_project) | Project path where the source image comes from. If not provided, this value<br>will default to the project hosting the slurm-gcp public images. More<br>information can be found in the slurm-gcp docs:<br>https://github.com/SchedMD/slurm-gcp/blob/v5.0.2/docs/images.md#public-image. | `string` | `null` | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Startup script that will be used by the login node VM. | `string` | `""` | no |
| <a name="input_static_ips"></a> [static\_ips](#input\_static\_ips) | List of static IPs for VM instances. | `list(string)` | `[]` | no |
| <a name="input_subnetwork_project"></a> [subnetwork\_project](#input\_subnetwork\_project) | The project that subnetwork belongs to. | `string` | `null` | no |
| <a name="input_subnetwork_self_link"></a> [subnetwork\_self\_link](#input\_subnetwork\_self\_link) | Subnet to deploy to. Either network\_self\_link or subnetwork\_self\_link must be specified. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Network tag list. | `list(string)` | `[]` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone where the instances should be created. If not specified, instances will be<br>spread across available zones in the region. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
