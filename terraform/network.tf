#=========================== Cоздаем облачную сеть ==========================

resource "yandex_vpc_network" "network" {
  name = "network-coursework"
}

#создаем подсеть zone A
resource "yandex_vpc_subnet" "network_a" {
  name           = "network-fops-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.10.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем подсеть zone C
resource "yandex_vpc_subnet" "network_d" {
  name           = "network-fops-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.30.0/24"]
  route_table_id = yandex_vpc_route_table.rt.id
}

#создаем NAT для выхода в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway"
  shared_egress_gateway {}
}

#создаем сетевой маршрут для выхода в интернет через NAT
resource "yandex_vpc_route_table" "rt" {
  name       = "fops-route-table"
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}