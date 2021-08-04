# Secure Swarm Node

This module deploys a Secure Swarm Node with Shielded instance configuration enabled 
and optionally confidential computing enabled.

Each node is configured with:
* `google_compute_disk` -  persistent storage, with "NVME" as the interface
* `google_compute_resource_policy` - Creates and attaches a snapshot schedule for the persistent disk.
Defaults to being run daily at 3:00. See [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy) for more details.
* `secure_instance_template` - Instance Template with shielded VM and optionally confidential computing enabled.
  Uses the previously created `google_compute_disk`
* `google_compute_instance_manager` - Managed Instance Group, with stateful disk set to never delete

The instance templates are deployed using a blue-green deployment approach.
The variable `deployment_version`, must be set to either `"blue"` or `"green"` for each deployment of this module.
For specifying specs for the blue or green version of a deployment the variable `blue_instance_template` or `green_instance_template`
should be updated with the configuration for the specified version. 
Not specifying configuration in those objects will default the values for that version to the `vars` that had been set

Using the Terraform experimental feature `module_variable_optional_attrs`, the `update_policy`, `blue_instance_template` and `green_instance_template` have optional attributes in the object.
To use this feature must be using terraform v.0.14.0+.

Required Variables for the module are:
* `project` - GCP project ID
* `deployment_version` - `"blue"` or `"green"` representing the `instance_template` version the `instance_group_manager` will use for the deploymetn
* `zone` - The zone the compute instances will be deployed in
* `security_level` - Level of security for instance template. Options are:
    * `"secure-1"` - Shielded VM settings enabled
    * `"confidential-1` - Same settings as `"secure-1"` but with confidential computing enabled as well

## Example Usage
This example demonstrates deployment of a 3-node secure-swarm with confidential compute settings enabled.
```hcl
module "secure_swarm_a" {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/secure_swarm_node"
  deployment_version = "blue"
  security_level = "confidential-1"
  zone = "a"
  project = "project"
  disk_size = 20
  service_account_email = "sa@project.iam.gserviceaccount.com"
  health_check = [{
    name              = "test-check"
    initial_delay_sec = 180
  }]
  access_config = {
    a = [{nat_ip = "10.0.0.2"}]
  }
  blue_instance_template = {}
  green_instance_template = {
    network = "network"
    subnetwork = "subnet"
  }
  
}
```