#=============================== Переменные =================================

#-------------------------------== ID Облака ==------------------------------
variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string

  # Чтобы не вводить каждый раз при terraform apply. Берётся в ЛК YC
  # default     = "ID вашего Yandex Cloud" 

}

#---------------------== ID папки, где будут создаваться ВМ ==---------------
variable "yc_folder_id" { # 
  description = "Yandex Cloud Folder ID"
  type        = string
  
   # Чтобы не вводить каждый раз при terraform apply. Берётся в ЛК YC
  # default     = "ID вашей папки в Yandex Cloud" 

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