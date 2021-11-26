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
