# Домашнее задание к занятию "Управляющие конструкции в коде Terraform" - Лебедев Антон

В папке src находится копия файлов проекта в конечном состоянии. Для удобства проверяющего в комментарии к каждому заданию вынесен кусок когда, касающийся данного задания.

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

**Задание 3**

Машина с дисками  описана так:
```
resource "yandex_compute_disk" "task_3_disk" {
    name   = "disk-${count.index}"
    count = 3
    type  = "network-hdd"
    zone  = "ru-central1-a"
    size  = 1
}

resource "yandex_compute_instance" "web_storage" {
  name        = "storage"
  platform_id = "standard-v1"
  depends_on = [yandex_compute_disk.task_3_disk]
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
    dynamic "secondary_disk" {
        for_each = yandex_compute_disk.task_3_disk
        content {
            disk_id = secondary_disk.value.id
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

**Задание 4**

ansible.cfg (извиняюсь за разброс и шатание в названиях сущностей, делал разные задания в разное время):
```
resource "local_file" "ansible_hosts" {
    depends_on = [ yandex_compute_instance.web_vm, yandex_compute_instance.for_each_vm, yandex_compute_instance.web_storage ]
    content = templatefile("./hosts.tftpl", 
    { 
        webservers = yandex_compute_instance.web_vm
        databases = yandex_compute_instance.for_each_vm
        storage = yandex_compute_instance.web_storage
    })
    filename = "ansible_hosts"
}
```

hosts.tftpl (пришлось из последнего раздела выкинуть цикл, потому что storage всего одно, там нет набора):
```
[webservers]
%{~ for i in webservers ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
%{~ endfor ~}


[databases]
%{~ for i in databases ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
%{~ endfor ~}


[storage]
${storage["name"]}   ansible_host=${storage["network_interface"][0]["nat_ip_address"]} fqdn=${storage["fqdn"]}
```

Вывод:

```
[webservers]
web-0   ansible_host=158.160.121.218 fqdn=fhm6ubtivjaegfo55kei.auto.internal
web-1   ansible_host=158.160.43.244 fqdn=fhm6esbsavkekenksgd0.auto.internal

[databases]
main   ansible_host=158.160.96.177 fqdn=fhm4tof9372t21i4lprp.auto.internal
replica   ansible_host=130.193.37.161 fqdn=fhm2ci3l0o30oukf8rd0.auto.internal

[storage]
storage   ansible_host=62.84.116.42 fqdn=fhm4vmaghfcafmjpqqkf.auto.internal
```

