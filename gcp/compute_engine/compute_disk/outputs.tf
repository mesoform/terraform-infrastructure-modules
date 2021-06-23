output "disk_name" {
  value = { for zone, disk in google_compute_disk.default : zone => disk.name }
}

output "disk_size" {
  value = { for zone, disk in google_compute_disk.default : zone => disk.size }
}