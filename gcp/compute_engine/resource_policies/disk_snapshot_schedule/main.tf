resource "google_compute_resource_policy" "disk_snapshot_schedule" {
  name    = var.name
  region  = var.region
  project = var.project
  snapshot_schedule_policy {
    schedule {
      dynamic "hourly_schedule" {
        for_each = var.snapshot_schedule.frequency == "hourly" ? [1] : []
        content {
          hours_in_cycle = var.snapshot_schedule.interval
          start_time     = var.snapshot_schedule.start_time
        }
      }
      dynamic "daily_schedule" {
        //If weekly or hourly schedule is specified ignore default daily schedule
        for_each = var.snapshot_schedule.frequency == "daily" ? [1] : []
        content {
          days_in_cycle = var.snapshot_schedule.interval
          start_time    = var.snapshot_schedule.start_time
        }
      }
      dynamic "weekly_schedule" {
        for_each = var.snapshot_schedule.frequency == "weekly" ? [1] : []
        content {
          dynamic "day_of_weeks" {
            for_each = var.snapshot_schedule.weekly_snapshot_schedule
            content {
              day        = day_of_weeks.value.day
              start_time = day_of_weeks.value.start_time
            }
          }
        }
      }
    }
    dynamic "retention_policy" {
      for_each = var.retention_policy == null ? [] : [1]
      content {
        max_retention_days    = var.retention_policy.max_retention_days
        on_source_disk_delete = lookup(var.retention_policy, "on_source_disk_delete", null)
      }
    }
    dynamic "snapshot_properties" {
      for_each = var.snapshot_properties == null ? [] : [1]
      content {
        labels            = lookup(var.snapshot_properties, "labels", null)
        storage_locations = lookup(var.snapshot_properties, "storage_locations", null)
        guest_flush       = lookup(var.snapshot_properties, "guest_flush", null)
      }
    }
  }
}