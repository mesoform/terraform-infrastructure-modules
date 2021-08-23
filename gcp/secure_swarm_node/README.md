# Secure Swarm Node

This module deploys a Secure Swarm Node with Shielded instance configuration enabled 
and optionally confidential computing enabled.

Required Variables for the module are:
* `project` - GCP project ID
* `deployment_version` - `"blue"` or `"green"` representing the `instance_template` version the `instance_group_manager` will use for the deploymetn
* `zone` - The zone the compute instances will be deployed in
* `security_level` - Level of security for instance template. Options are:
  * `"secure-1"` - Shielded VM settings enabled
  * `"confidential-1` - Same settings as `"secure-1"` but with confidential computing enabled as well

## Resources
### Compute Disks
Compute disks are configured with NVME interface with the name being <name>-<zone>-disk. These are configured with a snapshot schedule, which defaults to being done daily at 3am 
(see [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_resource_policy) for more details).

### Instance Templates
The instance templates are used for configuring the secure and confidential VMs. The name prefix will be <name>-<zone>-<blue/green>- and will be assigned a version, by the managed instance group, which is either the date-time, or a custom version name.

### Managed Instance Group
The instance group has the name <name>-<zone> and configures the ports, stateful disk, update policy and auto healing policies for the VM.  
If using the timestamp for the configuration, the version of the instance will update when there is a change to:
* Deployment version (blue or green)
* The fingerprint of the instance template corresponding to the deployment version
* Update Policy
* Health Check
* Named Ports  
Otherwise it will update when var.version is updated.

## Blue-Green Deployment
The instance templates are deployed using a blue-green deployment approach.
The variable `deployment_version`, must be set to either `"blue"` or `"green"` for each deployment of this module.
Specifying specs for the blue or green version of a deployment the variable `blue_instance_template` or `green_instance_template`
should be updated with the configuration for the specified version. 
Not specifying configuration in those objects will default the values for that version to the `vars` that had been set


Values for blue and green versions of the instance template are specified in `blue_instance_template` or `green_instance_template blocks`. 
If an attribute is not specified in the block, global values from the module or default variable values are used instead.

The variable `deployment_version` is used to specify whether the managed instance group will use the blue or green instance template. 
If changes are made to the template specified in `deployment_version`, the managed instance group will be updated with the new template.


Using the Terraform experimental feature `module_variable_optional_attrs`, the `update_policy`, `blue_instance_template` and `green_instance_template` have optional attributes in the object.
To use this feature must be using terraform v.0.14.0+.

## Example Usage
This example demonstrates deployment of a 2-node secure-swarm with confidential compute settings enabled. Each node is configured with its own module to allow for rolling updates.
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
    a = [{nat_ip = "35.0.0.2"}]
  }
  blue_instance_template = {}
  green_instance_template = {
    network = "network"
    subnetwork = "subnet"
    network_ip = {
      a = "10.0.0.2"
    }
  }
}

module "secure_swarm_b" {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/secure_swarm_node"
  deployment_version = "green"
  security_level = "confidential-1"
  zone = "b"
  project = "project"
  disk_size = 20
  service_account_email = "sa@project.iam.gserviceaccount.com"
  health_check = [{
    name              = "test-check"
    initial_delay_sec = 180
  }]
  access_config = {
    b = [{nat_ip = "35.0.0.3"}]
  }
  blue_instance_template = {}
  green_instance_template = {
    network = "network"
    subnetwork = "subnet"
    network_ip = {
      b = "10.0.0.3"
    }
  }
}
```



Disk Snapshot schedule configuration takes one of the following fomats:
```hcl
data_disk_snapshot_schedule = {
  frequency = "hourly" | "daily"
  interval = number
  start_time = time
} 

---------or----------

data_disk_snapshot_schedule = {
  frequency = "weekly"
  weekly_snapshot_schedule = [
    {
      day = "MONDAY" | "TUESDAY" | ... | "SUNDAY"
      start_time = time
    },
    ...
  ]
}
```