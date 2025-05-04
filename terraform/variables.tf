#=============================== Переменные =================================

#-------------------------------== ID Облака ==------------------------------
variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string

  # Перед git push удалить
  default     = "b1g51144vtfee9bo6o2e"
}

#---------------------== ID папки, где будут создаваться ВМ ==---------------
variable "yc_folder_id" { # 
  description = "Yandex Cloud Folder ID"
  type        = string
  
  # Перед git push удалить
  default     = "b1g08evp9r1vatdqt3nv"
}

#-------------------------== Зона сети по умолчанию ==-----------------------
variable "yc_zone" {
  description = "Yandex Cloud default zone"
  type        = string
  default     = "ru-central1-a"
}

#-----------------------== ID образа ОС по умолчанию ==----------------------
variable "yc_image_id" {
  description = "Debian 12 Yandex Cloud default image"
  default     = "fd8djec02sfvs6t3ojng"
}