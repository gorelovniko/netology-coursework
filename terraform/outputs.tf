output "bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "bastion-lan" {
  value = yandex_compute_instance.bastion.network_interface.0.ip_address
}

output "web-srv-1" {
  value = yandex_compute_instance.web-srv-1.network_interface.0.ip_address
}

output "web-srv-2" {
  value = yandex_compute_instance.web-srv-2.network_interface.0.ip_address
}

 output "kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}

output "grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}

output "balancer_ip" {
  value = yandex_alb_load_balancer.web-balancer.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}