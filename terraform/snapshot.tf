# resource "yandex_compute_snapshot_schedule" "daily-backup" {
#   name = "daily-snapshots"

#   schedule_policy {
#     expression = "0 0 * * *"
#   }

#   snapshot_count = 7

#   disk_ids = [
#     yandex_compute_instance.web1.boot_disk.0.disk_id,
#     yandex_compute_instance.web2.boot_disk.0.disk_id,
#     yandex_compute_instance.prometheus.boot_disk.0.disk_id,
#     yandex_compute_instance.grafana.boot_disk.0.disk_id,
#     yandex_compute_instance.elasticsearch.boot_disk.0.disk_id,
#     yandex_compute_instance.kibana.boot_disk.0.disk_id
#   ]
# }