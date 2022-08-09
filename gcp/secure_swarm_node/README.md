# Secure Swarm Node
### Contents
1. [Information](#information)
2. [Resources](#resources)
3. [Blue Green Deployment](#blue-green-deployment)
4. [Example Usage](#example-usage)
5. [Post deployment Steps](#post-deployment-steps)
6. [Troubleshooting](#troubleshooting)


##  Information
This module deploys a Managed Instance Group (MIG), which creates instances with Shielded Instance Configuration enabled 
and optionally [confidential computing](https://cloud.google.com/compute/confidential-vm/docs/about-cvm) enabled, 
to be used as a secure docker swarm node.

### Prerequisites
* GCP project with Compute Engine API enabled
* Billing account for project

### Required variables
* `project` - GCP project ID
* `deployment_version` - `"blue"` or `"green"` representing the `instance_template` version the `instance_group_manager` will use for the deployment
  (defaults to `"green"`)
* `security_level` - Level of security for instance template. Options are:
  * `"secure-1"` - Shielded VM settings enabled
  * `"confidential-1` - Same settings as `"secure-1"` but with confidential computing enabled as well

## Resources

### Instance Templates
The instance templates are used by the Instance Group Manager to deploy the specified secure/confidential VMs. 
The name prefix will be `${var.name}-${var.zone}-${var.deployment_version}-` and will be assigned a version on deployment.

The template defines:
* Compute instance shielded/confidential configuration
* Source image for boot disk
* Persistent disk config (if `persisent_disk = true`)
  * Disk `interface` is set to `NVME` if using confidential computing, otherwise it is `SCSI`
  * This disk **will NOT be deleted** on `terraform destroy`, as is created outside terraform. 
    Persistent disk removal must be done manually.
  * A resource policy (e.g. snapshot schedule), can be attached to the disk by setting `disk_resource_policies` 
    as a list of resource policies to attach.
* Network configuration
  * VPC network to use
  * Optional network IP and external IP to use


### Managed Instance Group
The module deploys either a zonal (default) or regional instance group manager, with either a stateful (default) or stateless configuration.  
If `zone` is set, an MIG will be deployed in `${var.region}-${var.zone}`, with the name `${var.name}-${var.zone}`.  
If `zone` is null, a regional MIG will be deployed instead, and will just have the name set in the `name` variable.

The MIG can either be stateful (default) or set to stateless by setting `stateful_instance_group=false`.
If using a persistent disks, the maximum `target_size` is 1 (see [troubleshooting](#the-instance-template-cannot-be-used-to-create-more-than-one-instance-per-zone)).

If the `update_policy` or `regional_update_policy` is configured to do so, the instances deployed from MIG will update when the version changes.
If `version_name` is not set, a timestamp is used for the `version` configuration. 
The timestamp, and therefore the version, is updated when there is a change to one of the following:
* Deployment version (blue or green)
* The fingerprint of the instance template corresponding to the deployment version
* Update Policy
* Health Check
* Named Ports  

Otherwise, it will update when `version_name` is updated. NOTE: This module currently only deploys 1 version at a time.

#### Confidential Compute Instance configuration
To use auto healing in the MIG with confidential compute instances, the boot disk must be set as stateful (see [troubleshooting](#instance-update-failed-nvme-interface-must-be-specified-when-the-disk-is-created-rather-than-during-attachment)).  
If `stateful_disk_delete_rule` is set to `NEVER`, the boot disk will persist after deletion of the instance it was attached to. 
If it is set to `ON_PERMANENT_INSTANCE_DELETION`:
* Boot disk **persists** and is reattached to instance when:
  * Auto healing recreates instance after health check fail
  * Instance is stopped using `gcloud compute instances stop`
  * instance is deleted using `gcould compute insattnces delete`
* Boot disk is **deleted** when
  * instance group manager `target_size = 0` and `terraform apply` is done. 

If updating the `source_image` in the instance template, the image will not be updated on the instance in any of the above scenarios where the disk persists. 
To update the image on instances:
1. Set `target_size = 0`
2. Run `terraform apply` and wait for instance group to finish updating
3. Set `target_size = 1`
4. Run `terraform apply` again, and the instance will be recreated with new image on disk

**NOTE:** If instance is a swarm node, it will rejoin the swarm in any of the instances where the boot disk persists. 
But, if not configured to on the image in use, will not rejoin after boot disk is deleted.

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
  project = var.project
  disk_size = 20
  service_account_email = "sa@project.iam.gserviceaccount.com"
  health_check = [{
    name              = "test-check"
    initial_delay_sec = 180
  }]
  access_config = [{nat_ip = "35.0.0.2"}]
  blue_instance_template = {}
  green_instance_template = {
    network = "network"
    subnetwork = "subnet"
    network_ip = "10.0.0.2"
  }
}

data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
}

module "secure_swarm_regional" {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/secure_swarm_node"
  deployment_version = "green"
  security_level = "confidential-1"
  stateful_instance_group = false
  persistent_disk = false
  region = var.region
  project = var.project
  service_account_email = "sa@project.iam.gserviceaccount.com"
  health_check = [{
    name              = "test-check"
    initial_delay_sec = 180
  }]
  access_config = [{nat_ip = "35.0.0.3"}]
  blue_instance_template = {}
  green_instance_template = {
    network = "network"
    subnetwork = "subnet"
    network_ip = "10.0.0.3"
  }
  regional_update_policy = [{
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 0
    max_unavailable_fixed        = length(data.google_compute_zones.available.names)
    replacement_method           = "RECREATE"
  }]
}

module "stateful_secure_swarm_regional" {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/secure_swarm_node"
  deployment_version = "green"
  security_level = "confidential-1"
  region = var.region
  project = var.project
  stateful_instance_group = true
  persistent_disk = true
  disk_size = 20
  service_account_email = "sa@project.iam.gserviceaccount.com"
  health_check = [{
    name              = "test-check"
    initial_delay_sec = 180
  }]
  access_config = [{nat_ip = "35.0.0.3"}]
  regional_update_policy = [{
    type                         = "PROACTIVE"
    instance_redistribution_type = "NONE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 0
    max_unavailable_fixed        = length(data.google_compute_zones.available.names)
    replacement_method           = "RECREATE"
  }]
}
```

## Post Deployment Steps
### 1. Mount Persistent Data Disk
If using a persistent data disk, it must be formatted and mounted after the initial creation of the disk. 
Formatting is not required if attaching an existing, previously formatted disk, as data loss would occur.  
Find the name of the device to mount, if the `security_level` was set to `confidential-1` the device name should be `nvme0n2`,
and if it was set to `secure-1` it should be `sdb` (the boot disk would be `nvme0n1` and `sda` respectively). Confirm this with `sudo lsblk`.  
E.g on Confidential VM:
```shell
$ sudo lsblk
...
nvme0n1      259:0    0   100G  0 disk 
├─nvme0n1p1  259:1    0  99.9G  0 part /
├─nvme0n1p14 259:2    0     4M  0 part 
└─nvme0n1p15 259:3    0   106M  0 part /boot/efi
nvme0n2      259:4    0   512G  0 disk 
```
Format the disk, e.g.:
```shell
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/nvme0n2
```
Mount the disk in desired folder e.g. at `/data`:
```shell
sudo mount -o discard,defaults /dev/nvme02 /data
```
To mount the disk on automatically on restart, edit the `/etc/fstab` file to include one of the following lines:
```shell
# Confidential VM
/dev/nvme0n2 /data 	ext4	defaults	0 0

# or Shielded VM
/dev/sdb  /data 	ext4	defaults	0 0
```

## Troubleshooting
### Instance update failed: NVME interface must be specified when the disk is created rather than during attachment
 
Likely scenarios this occurs in:
* Instance template configured with existing persistent disk, which did not have `interface` set to `NVME` on creation. 
  * Use an existing disk that was created with `NVME` interface specified
  * Use disk created with this module in the [instance template](#instance-templates) configuration
* During auto-healing by MIG, if not set as stateful, the boot disk will be recreated as `${boot-disk-name}-temp`. 
  That disk has an interface of `SCSI` regardless of the interface configuration in the used instance template. 
  This instance will be recreated, but unable to join the instance group, so recreation will be indefinite until either:
  * MIG is scaled down to 0 instance, then scaled back up to 1 to create a completely new instance and boot disk from the specified template
  * Set `stateful_boot` to `true` to have persistence on the boot disk (see [config documentation](#confidential-compute-instance-configuration)),
    meaning the interface is never changed from `NVME`, allowing recreated instance to rejoin the instance group

### The instance template cannot be used to create more than one instance per zone
```shell
│ Error: Error waiting for Creating InstanceGroupManager: Invalid value for field 'operation': ''. 
  The instance template cannot be used to create more than one instance per zone in the instance group. 
  This is because the instance template has attached a disk definition with a custom disk name and only one disk with a specific name can exist in a zone. 
  To create more than one instance, set the name of the disk to instance name or Autogenerated.
```
The persistent-disk name in this module is set to be `${var.name}-data`. 
Set the `target_size` to a maximum of 1 if using a persistent disk. 
