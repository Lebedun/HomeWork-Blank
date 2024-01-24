# Домашнее задание к занятию "Управляющие конструкции в коде Terraform" - Лебедев Антон

**Задание 1**

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/t03/img/Screenshot_1.jpg)

**Задание 2**

count-vm.tf:

```
resource "yandex_compute_instance" "web_vm" {
  name        = "web-${count.index}"
  platform_id = "standard-v1"
  
  count = 2

  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type = "network-hdd"
      size = 5
    }   
  }

  metadata = {
    ssh-keys = var.vms_metadata.ssh-keys
  }

  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}

```
