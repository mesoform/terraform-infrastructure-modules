variable "name" {
  type = string
  default = "snapshot-schedule"
}

variable "project" {
  type = string
}
variable "region" {
  type = string
}

variable snapshot_schedule {
  description = "Hourly, Daily or Weekly snapshot schedule, must be 24hour format"
  type = object({
    frequency = string
    start_time = optional(string)
    interval   = optional(number)
    weekly_snapshot_schedule = optional(list(object({
      day        = string
      start_time = string
    })))
  })

  default = {
    frequency  = "daily"
    interval   = 1
    start_time = "03:00"
  }

  validation {
    condition     = contains(["hourly", "daily", "weekly"], var.snapshot_schedule.frequency)
    error_message = "Frequency must be either 'hourly', 'daily', 'weekly'."
  }
}

variable "retention_policy" {
  description = "Retention Policy Applied to snapshots"
  type = object({
    max_retention_days    = number
    on_source_disk_delete = optional(string)
  })
  default = null
}

variable "snapshot_properties" {
  type = object({
    labels            = optional(map(string))
    storage_locations = optional(list(string))
    guest_flush       = optional(string)

  })
  default = null
}

variable disks {
  type = map(string)
  description = "Map of key value pairs of disk and zone. E.g. {disk1: 'europe-west2-a'}"
  default = {}
}

variable regional_disks {
  type = set(string)
  description = "List of regional disks to attach schedule to"
  default = {}
}

