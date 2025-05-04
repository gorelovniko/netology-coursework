#========================= Провайдер для terraform ==========================

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      # version = "0.129.0"
    }
  }

  required_version = ">=1.8.4"
}

provider "yandex" {
  # token                  = "do not use!!!"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  service_account_key_file = file("../authorized_key.json")
}