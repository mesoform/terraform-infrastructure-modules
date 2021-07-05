# Secure Swarm Node

This module deploys a Secure Swarm Node with Shielded instance configuration enabled 
and optionally confidential computing enabled.

Each node is configured with:
* `google_compute_disk` -  persistent storage, with "NVME" as the interface
* `secure_instance_template` - Instance Template with shielded VM and optionally confidential computing enabled. 
Uses the previously created `google_compute_disk`
* `google_compute_instance_manager` - Managed Instance Group, with stateful disk set to never delete

Required Variables are:
* `project` - GCP project ID
* `zone` - The zone the compute instances will be deployed in
* `security_level` - Level of security for instance template. Options are:
    * `"secure-1"` - Shielded VM settings enabled
    * `"confidential-1` - Same settings as `"secure-1"` but with confidential computing enabled as well

## Example Usage
This example demonstrates deployment of a 3-node secure-swarm with confidential compute settings enabled.
```hcl
module "secure_swarm" {
  source = "github.com/mesoform/terraform-infrastructure-modules//gcp/secure_swarm_node"
  for_each = toset(["a", "b", "c"])
  security_level = "confidential-1"
  zone = each.value
  project = "project"
  disk_size = 20
  service_account_email = "sa@project.iam.gserviceaccount.com"
  health_check = [{
    name              = "test-check"
    initial_delay_sec = 180
  }]
  access_config = {
    a = [{nat_ip = "0.0.0.2"}, {nat_ip = "0.0.0.3"}],
    b = [{nat_ip = "0.0.0.6"}],
    c = [{nat_ip = "0.0.0.5"}]
  }
}
```