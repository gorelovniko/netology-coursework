# resource "yandex_alb_target_group" "web-servers" {
#   name = "web-servers-tg"

#   target {
#     subnet_id  = yandex_vpc_subnet.network_a.id
#     ip_address = yandex_compute_instance.web-srv-1.network_interface.0.ip_address
#   }

#   target {
#     subnet_id  = yandex_vpc_subnet.network_b.id
#     ip_address = yandex_compute_instance.web-srv-2.network_interface.0.ip_address
#   }
# }

# resource "yandex_alb_backend_group" "web-backend" {
#   name = "web-backend-group"

#   http_backend {
#     name             = "web-http-backend"
#     weight          = 1
#     port            = 80
#     target_group_ids = [yandex_alb_target_group.web-servers.id]
    
#     healthcheck {
#       timeout          = "10s"
#       interval         = "2s"
#       healthy_threshold   = 5
#       unhealthy_threshold = 3
#       http_healthcheck {
#         path = "/"
#       }
#     }
#   }
# }

# resource "yandex_alb_http_router" "web-router" {
#   name = "web-router"
# }

# resource "yandex_alb_virtual_host" "web-host" {
#   name           = "web-host"
#   http_router_id = yandex_alb_http_router.web-router.id
#   route {
#     name = "root"
#     http_route {
#       http_route_action {
#         backend_group_id = yandex_alb_backend_group.web-backend.id
#         timeout         = "60s"
#       }
#     }
#   }
# }

# resource "yandex_alb_load_balancer" "web-balancer" {
#   name               = "web-balancer"
#   network_id         = yandex_vpc_network.network.id

#   allocation_policy {
#     location {
#       zone_id   = "ru-central1-a"
#       subnet_id = yandex_vpc_subnet.network_a.id
#     }
#   }

#   listener {
#     name = "web-listener"
#     endpoint {
#       address {
#         external_ipv4_address {
#         }
#       }
#       ports = [80]
#     }
#     http {
#       handler {
#         http_router_id = yandex_alb_http_router.web-router.id
#       }
#     }
#   }
# }




# Создаем Target Group с двумя ВМ
resource "yandex_alb_target_group" "web-servers" {
  name = "web-servers-tg"

  target {
    subnet_id  = yandex_vpc_subnet.network_a.id
    ip_address = yandex_compute_instance.web-srv-1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.network_d.id
    ip_address = yandex_compute_instance.web-srv-2.network_interface.0.ip_address
  }
}

# Создаем Backend Group
resource "yandex_alb_backend_group" "web-backend" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.web-servers.id]
    
    healthcheck {
      timeout          = "10s"
      interval         = "2s"
      healthcheck_port = 80
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# Создаем HTTP Router
resource "yandex_alb_http_router" "web-router" {
  name = "web-router"
}

# Создаем Virtual Host и Route
resource "yandex_alb_virtual_host" "web-host" {
  name           = "web-host"
  http_router_id = yandex_alb_http_router.web-router.id
  
  route {
    name = "root-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web-backend.id
      }
    }
  }
}

# Создаем Application Load Balancer
resource "yandex_alb_load_balancer" "web-balancer" {
  name        = "web-balancer"
  network_id  = yandex_vpc_network.network.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-d"
      subnet_id = yandex_vpc_subnet.network_d.id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web-router.id
      }
    }
  }
}