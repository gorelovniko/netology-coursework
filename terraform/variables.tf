#=============================== Переменные =================================

#-------------------------------== ID Облака ==------------------------------
variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string

}

#---------------------== ID папки, где будут создаваться ВМ ==---------------
variable "yc_folder_id" { # 
  description = "Yandex Cloud Folder ID"
  type        = string
  
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