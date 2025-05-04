#--------------------------security_group------------------------



#создаем группы безопасности(firewall)

# ---------------------- Security Bastion --------------------

resource "yandex_vpc_security_group" "bastion-sg" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.network.id
  
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22                  # Сменить порт SSH по умолчанию?
  }

 # Добавьте правило для мониторинга
#   ingress {
#     description       = "Prometheus metrics"
#     protocol         = "TCP"
#     port             = 9100
#     security_group_id = yandex_vpc_security_group.monitoring_sg.id
# }
 
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}


# resource "yandex_vpc_security_group" "LAN-sg" {
#   name       = "LAN-sg"
#   network_id = yandex_vpc_network.network.id
# #   ingress {
# #     description    = "Allow 10.0.0.0/8"
# #     protocol       = "ANY"
# #     v4_cidr_blocks = ["10.0.0.0/8"]
# #     from_port      = 0
# #     to_port        = 65535
# #   }
#     ingress {
#     description       = "SSH from Bastion"
#     protocol         = "TCP"
#     v4_cidr_blocks = ["10.0.0.0/8"]
#     port             = 22
#     security_group_id = yandex_vpc_security_group.bastion_sg.id
#   }
#     ingress {
#     description    = "HTTP for web servers"
#     protocol       = "TCP"
#     port           = 80
#     v4_cidr_blocks = ["10.0.0.0/8"] # Разрешаем HTTP для всех
#   }
#   egress {
#     description    = "Permit ANY"
#     protocol       = "ANY"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     from_port      = 0
#     to_port        = 65535
#   }

# }


resource "yandex_vpc_security_group" "web-sg" {
  name       = "web-sg"
  network_id = yandex_vpc_network.network.id
  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


# ---------------------Security SSH Traffic----------------------

resource "yandex_vpc_security_group" "ssh-traffic-sg" {
  name       = "ssh-traffic-sg"
  network_id = yandex_vpc_network.network.id
 
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }
}

# ---------------------Security WebServers-------------------------

resource "yandex_vpc_security_group" "webservers-sg" {
  name       = "webservers-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 4040
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------Security Prometheus-------------------------

resource "yandex_vpc_security_group" "prometheus-sg" {
  name       = "prometheus-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  ingress {
    description    = "Node-Exporter traffic"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------Security Grafana-----------------------

resource "yandex_vpc_security_group" "grafana-sg" {
  name       = "grafana-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------Security ElasticSearch----------------------

resource "yandex_vpc_security_group" "elasticsearch-sg" {
  name       = "elasticsearch-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------Security Kibana-----------------------

resource "yandex_vpc_security_group" "kibana-sg" {
  name       = "kibana-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------Security Public Load Balancer---------------

resource "yandex_vpc_security_group" "alb-sg" {
  name       = "alb-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol          = "ANY"
    description       = "Health checks"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "load_balancer_healthchecks"
  }

  ingress {
    protocol       = "TCP"
    description    = "allow HTTP connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "allow HTTPS connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "ICMP"
    description    = "allow ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}