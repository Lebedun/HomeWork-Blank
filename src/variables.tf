###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = 1
    ssh-keys = "***"
  }
}

variable "image_name_string" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Linux distro name"
}

## type = list(object({ ... })) - заставить работать не удалось, for_each требует в качестве "перечисляемого" map или list of strings 
## проще всего оказалось вообще убрать тип у переменной (поэтому notype) и дать terraform выбрать подходящий по её присваиванию.

variable "each_vm_params_notype" {
  default={}
}

## count-vm #################################################

variable "count-vm-platform" {
  type = string
  default = "standard-v1"
}

variable "count-vm-count" {
  type=number
  default = 2  
}

variable "count-vm-cores" {
  type=number
  default = 2  
}

variable "count-vm-memory" {
  type=number
  default = 1  
}

variable "count-vm-core_fraction" {
  type=number
  default = 5  
}

variable "count-vm-boot_disk-type" {
  type=string
  default = "network-hdd"  
}

variable "count-vm-boot_disk-size" {
  type=number
  default = 5  
}

## for_each ############################################3

variable "for_each-vm-platform" {
  type = string
  default = "standard-v1"
}



variable "for_each-vm-core_fraction" {
  type=number
  default = 5  
}

variable "for_each-vm-boot_disk-type" {
  type=string
  default = "network-hdd"  
}

## disk ############################################3

variable "disk-vm-platform" {
  type = string
  default = "standard-v1"
}

variable "disk-vm-cores" {
  type=number
  default = 2  
}

variable "disk-vm-memory" {
  type=number
  default = 1  
}

variable "disk-vm-core_fraction" {
  type=number
  default = 5  
}

variable "disk-vm-boot_disk-type" {
  type=string
  default = "network-hdd"  
}

variable "disk-vm-boot_disk-size" {
  type=number
  default = 5  
}

## task_3_disk #############################################

variable "task_3_disk-count" {
  type=number
  default = 3  
}

variable "task_3_disk-type" {
  type=string
  default = "network-hdd"  
}

variable "task_3_disk-size" {
  type=number
  default = 1  
}

