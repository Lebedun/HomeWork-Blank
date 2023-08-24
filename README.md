# Домашнее задание к занятию "Отказоустойчивость в облаке" - Лебедев Антон


## Задание 1 

Возьмите за основу [задание 1 из модуля 7.3 «Подъём инфраструктуры в Яндекс Облаке»](https://github.com/netology-code/sdvps-homeworks/blob/main/7-03.md#задание-1).

Теперь вместо одной виртуальной машины сделайте terraform playbook, который:

- создаст 2 идентичные виртуальные машины. Используйте аргумент [count](https://www.terraform.io/docs/language/meta-arguments/count.html) для создания таких ресурсов;
- создаст [таргет-группу](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_target_group). Поместите в неё созданные на шаге 1 виртуальные машины;
- создаст [сетевой балансировщик нагрузки](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer), который слушает на порту 80, отправляет трафик на порт 80 виртуальных машин и http healthcheck на порт 80 виртуальных машин.

Рекомендую почитать [документацию сетевого балансировщика](https://cloud.yandex.ru/docs/network-load-balancer/quickstart) нагрузки для того, чтобы было понятно, что вы сделали.

Далее установите на созданные виртуальные машины пакет Nginx любым удобным способом и запустите Nginx веб-сервер на порту 80.

Далее перейдите в веб-консоль Yandex Cloud и убедитесь, что: 

- созданный балансировщик находится в статусе Active,
- обе виртуальные машины в целевой группе находятся в состоянии healthy.

Сделайте запрос на 80 порт на внешний IP-адрес балансировщика и убедитесь, что вы получаете ответ в виде дефолтной страницы Nginx.

*В качестве результата пришлите:*

*1. Terraform Playbook.*

В meta.txt ничего интересного, кроме ключа доступа к ВМ. Как засунуть count в target, чтобы можно было менять просто аргумент (через переменную) - так и не придумал =(. Вроде как на версии Terraform ниже 0.12 count можно было вставлять не только в resource, но что сейчас вместо этого механизма предложено - непонятно.

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token = "y0_AgAAAA...c4"
  cloud_id = "b1gs...34"
  folder_id = "b1gr...4b"
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "tfvms" {
  count = 2
  name = "terraform${count.index}"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kvc2easore7l8ql6q"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_target_group" "trgtgrp" {
  name                   = "targetgroup1"
  dynamic target {
  for_each = yandex_compute_instance.tfvms
    content {
       subnet_id            = yandex_vpc_subnet.subnet-1.id
       address              = target.value.network_interface.0.ip_address
    }
  }
}


resource "yandex_lb_network_load_balancer" "ldblncr" {
  name = "loadbalancer1"
  listener {
    name = "testlistener"
    port = 80
    external_address_spec {
      ip_version="ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.trgtgrp.id
    healthcheck {
      name = "http"
      http_options {
          port = 80
          path = "/"
      }
    }
  }
}
```

*2. Скриншот статуса балансировщика и целевой группы.*

![Screenshot_2](https://github.com/Lebedun/HomeWork-Blank/blob/10-07/img/Screenshot_2.jpg)

*3. Скриншот страницы, которая открылась при запросе IP-адреса балансировщика.*

![Screenshot_3](https://github.com/Lebedun/HomeWork-Blank/blob/10-07/img/Screenshot_3.jpg)

