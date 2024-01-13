# Домашнее задание к занятию "Основы Terraform. Yandex Cloud" - Лебедев Антон

В папке src находится копия файлов проекта в конечном состоянии. Для удобства проверяющего в комментарии к каждому заданию вынесен кусок когда, касающийся данного задания.

Область доступности второй машины поменял обратно на ru-central1-a из-за странного глюка облака - в какой-то момент машины в ru-central1-b перестали создаваться. Позже поменял обратно на b - снова заработало. Больше ничего связанного с сетью не менял в этот момент. Причину не понимаю, возможно, какой-то временный внутренний глюк облака.

P.S. похоже, сейчас при указании любой зоны ВМ создаются только в зоне а.

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
**Задание 3**

Для того, чтобы разместить ВМ в другой зоне, пришлось добавить привязанную к этой зоне подсеть.

**Задание 4**

Получилось несколько топорно:
```
output "vm_info" {
value = join("\n", [yandex_compute_instance.platform.name, 
                    yandex_compute_instance.platform.fqdn, 
                    yandex_compute_instance.platform.network_interface[0].nat_ip_address,
                    yandex_compute_instance.platform_db.name, 
                    yandex_compute_instance.platform_db.fqdn,
                    yandex_compute_instance.platform_db.network_interface[0].nat_ip_address]
            )
}
```

Но сработало:
```
lebedev@nworkstation:~/homeworks/t02/src$ terraform output
vm_info = <<EOT
netology-develop-platform-web
fhmojbc0ogi4s7bveqej.auto.internal
158.160.126.162
netology-develop-platform-db
epdg9l410mujacc1njfb.auto.internal
84.201.162.177
EOT
```

**Задание 5**

Скопировал строку с примером формирования переменной с презентации. Убил два часа на поиски ошибки. Минус в середине формулы оказался каким-то другим символом, хотя визуально выглядел так же...

```
locals {
    local_web_name = "netology-${ var.env }-${ var.obj }-web"
    local_db_name = "netology-${ var.env }-${ var.obj }-db"    
}
```

**Задание 6**

Очень жаль, что в переменных внутри нельзя ссылаться на другие переменные. Получилось только вот так:

```
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
```

И вот так:
```
variable "vms_metadata" {
  type = map(string)
  default = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:ssh-ed25519 AAAAC3N******************************************R5R lebedev@nworkstation"
  }
}
```
