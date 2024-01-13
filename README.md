# Домашнее задание к занятию "Основы Terraform. Yandex Cloud" - Лебедев Антон

**Задание 1**

Ошибки:

  platform_id = "standart-v4" - неверно, нет такой платформы. Опечатка в слове standard и в номере платформы. 
  Некорректный параметр cores (не может быть равным 1)

Исправил к следующему виду (возможны варианты):

```
platform_id = "standard-v1"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
```

Preemptible=true создаёт прерываемую ВМ, которая отключается через 24 часа после запуска либо при нехватке ресурсов для других ВМ той же зоны доступности. Это дешевле, плюс нет риска забыть её включенной и впустую израсходовать средства на учебном примере.

core_fraction=5 означает гарантированный доступ к указанному числу физических ядер в течение 5% времени. Такая ВМ годится только для учебных целей (так как не может поддерживать задачи, создающие высокую нагрузку на процессор), но гораздо дешевле.


![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/t02/img/Screenshot_1.jpg)

**Задание 2**
В variables.tf добавился следующий код:

```
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

variable "vm_web_cores" {
  type        = number
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  default     = 1
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
}

variable "vm_web_nat" {
  type        = bool
  default     = true
}

variable "vm_web_serial-port-enable" {
  type        = number
  default     = 1
}
```
А соответствующий блок в main.tf стал выглядеть так:

```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```
Конфигурация не изменилась:

```
lebedev@nworkstation:~/homeworks/t02/src$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpp252gjtfoetfofbnt]
data.yandex_compute_image.ubuntu: Read complete after 0s [id=fd8hv2dssq4boeimr8hc]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bi07te9kgs6js65drb]
yandex_compute_instance.platform: Refreshing state... [id=fhmojbc0ogi4s7bveqej]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```
