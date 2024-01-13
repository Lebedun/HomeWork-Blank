variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
}

#variable "vm_web_cores" {
#  type        = number
#  default     = 2
#}

#variable "vm_web_memory" {
#  type        = number
#  default     = 1
#}

#variable "vm_web_core_fraction" {
#  type        = number
#  default     = 5
#}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
}

variable "vm_web_nat" {
  type        = bool
  default     = true
}

#variable "vm_web_serial-port-enable" {
#  type        = number
#  default     = 1
#}


#################################################################


variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
}

#variable "vm_db_cores" {
#  type        = number
#  default     = 2
#}

#variable "vm_db_memory" {
#  type        = number
#  default     = 2
#}

#variable "vm_db_core_fraction" {
#  type        = number
#  default     = 20
#}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
}

variable "vm_db_nat" {
  type        = bool
  default     = true
}

#variable "vm_db_serial-port-enable" {
#  type        = number
#  default     = 1
#}

##########################################

variable "env" {
  type = string
  default = "develop"
}

variable "obj" {
  type = string
  default = "platform"
}

variable "vms_resources" {
  type = map(map(string))
  default={
    web={
      cores=2
      memory=1
      core_fraction=5
    }  
    db={
      cores=2
      memory=2
      core_fraction=20
    }
  }  
}

variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = 1
    ssh-keys = "***"
  }
}
