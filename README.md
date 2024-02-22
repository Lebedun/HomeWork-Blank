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

for_each-vm.tf
```
resource "yandex_compute_instance" "for_each_vm" {

    for_each = var.each_vm_params_notype
    depends_on = [yandex_compute_instance.web_vm]
    name = each.value.name
    platform_id = "standard-v1"
    resources {
        cores  = each.value.cores
        memory = each.value.memory
        core_fraction = 5
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
            type = "network-hdd"
            size = each.value.disk_volume
        }   
    }
    metadata = { ssh-keys =file("~/.ssh/id_rsa_ubuntu.pub") }
    scheduling_policy { preemptible = true }
    network_interface { 
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = true
    }
    allow_stopping_for_update = true
}
```

Переменная задана так:
```
each_vm_params_notype = {
  main_vm = {
    name        = "main",
    cores       = 4,
    memory      = 4,
    disk_volume = 40,    
  }
  replica_vm = {
    name        = "replica",
    cores       = 2,
    memory      = 2,
    disk_volume = 20,    
  }
}
```
