# Disk snapshot schedule
This module creates a disk snapshot schedule, and can optionally attach the schedule to a set of disks.

Required variables:
* `project` - GCP project
* `name` - Name of the snapshot schedule
* `region` - Snapshot schedule region. If attaching snapshot schedule to regional compute disks, 
             the disks must be in this region.

Other variables:
* The `retention_policy` variable is a map defining how long a snapshot should be kept and has:
  * `max_retention_days` - Number of days to keep the variable
  * `on_source_disk_delete` - Specifies what to do to a scheduled snapshot if the disk it is attached to is deleted. 
     Possible values are:
    * `KEEP_AUTO_SNAPSHOTS` (default) 
    * `APPLY_RETENTION_POLICY`
* The `snapshot_properties` variabled is a map defining configuration for the snapshot:
    * `labels` - snapshot labels
    * `storage_locations` - Cloud storage bucket location to autostore snapshot (e.g. `["europe-west2"]`)
    * `guest_flush` - Whether to flush all pending writes from memory to disk before the snapshot is capture
* The `shapshot_schdeule` variable is a map defining when snapshots should be taken, and has the following values:  
  * `frequency` - One of `"hourly"` `"daily"` or `"weekly"` (Default `"daily"`)
  * `interval` - If using `hourly` or `daily` snapshots, defines the interval between snapshots (Default `1`)
  * `weekly_snapshot_schedule` - If doing weekly, include a list of mapptings with the `day` and `start_time` of the snapshot



Example `snapshot_schedule` configurations:
```terraform
snapshot_schedule = {
  frequency = "daily"
  interval = number
  start_time = time
}
snapshot_schedule = {
  frequency = "weekly"
  weekly_snapshot_schedule = [
    {
      day = "TUESDAY"
      start_time = "23:00"
    },
    {
      day = "FRIDAY"
      start_time = "03:00"
    }
  ]
}
```

### Attaching snapshot to disks
If there are existing disks that the created snapshot schedule should be applied to, 
they can be specified and managed by the `google_compute_disk_resource_policy_attachment` resource.
To specify disks the schedule should be attached to list define:
* `disks` - A map with the disk name as the key, and it's zone as the value (**NOTE** disks must be in the same region). 
  E.g. 
  ```terraform
  disks = {
    disk1 = "europe-west2-a"
    disk2 = "europe-west2-b"
  }
  ```
* `regional disk` - A list of regional disks within the same region as the snapshot schedule

### Destroying resource
_**NOTE**: A snapshot schedule cannot be deleted if it is attached to a disk._  
If `disks` and/or `regional_disks` were specified, the schedule will be detached from disks, and then deleted, when running `terraform destroy`.  
If schedule was attached to disks outside the control of this module, the schedule needs to be detached before `terraform destroy`.   
Options for doing this are:
* **Google Cloud Console** - Go to  `Compute engine > disks > DISK_NAME > edit` 
  and then set `Snapshot Schedule` to `No schedule`
* **gcloud** - Run :
  ```shell
    gcloud compute disks remove-resource-policies DISK_NAME
        --resource-policies=[RESOURCE_POLICY]
        [--region=REGION | --zone=ZONE]
  ```
* **Terraform** - Import resource attachment for disks before running `terraform destroy`
  ```shell
  terraform import google_compute_disk_resource_policy_attachment.self PROJECT/ZONE/DISK/SNAPSHOT_SCHEDULE_NAME
  
  #If this module is being referenced as a submodule, the import command will be
  terraform import module.PARENT_MODULE_NAME.google_compute_disk_resource_policy_attachment.self PROJECT/ZONE/DISK/SNAPSHOT_SCHEDULE_NAME
  ```