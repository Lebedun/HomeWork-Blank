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

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/t02/img/Screenshot_1.jpg)

