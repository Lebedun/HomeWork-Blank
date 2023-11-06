# Домашнее задание к занятию "Применение принципов IaaC в работе с виртуальными машинами" - Лебедев Антон

---

## Задача 1

*Опишите основные преимущества применения на практике IaaC-паттернов.*

 - Скорость и цена,
 - Стабильность и надёжность.

*Какой из принципов IaaC является основополагающим?*

Идемпотентность (одинаковые условия - одинаковый результат).

---

## Задача 2

*Чем Ansible выгодно отличается от других систем управление конфигурациями?*

 - Скорость
 - Простота
 - Расширяемость
 - Универсальность (для работы нужны только ssh и python, доступные почти везде)
 - Возможность сочетания декларативного и императивного подходов

*Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?*

Из общих соображений - push, так как неудача будет сразу видна в момент попытки, тогда как при использовании pull неудачная попытка (настолько неудачная, что "принимающая сторона" полностью сломалась и не выдала никаких сообщений), отсутствие попытки вообще (принимающая сторона недоступна или сломалась ещё до наших попыток и не пыталась ничего получить) и удачная попытка, после которой не было никакого подтверждения (не настроили) выглядят одинаково.

---

## Задача 3

*Установите на личный linux-компьютер(или учебную ВМ с linux):*

- *[VirtualBox](https://www.virtualbox.org/),*
- *[Vagrant](https://github.com/netology-code/devops-materials), рекомендуем версию 2.3.4(старшие версии могут возникать проблемы интеграции с ansible)*
- *[Terraform](https://github.com/netology-code/devops-materials/blob/master/README.md)  версии 1.5.Х (1.6.х может вызывать проблемы с яндекс-облаком),*
- *Ansible.*

*Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.*

```
lebedev@nworkstation:~$ VBoxManage --version
7.0.12r159484
```

```
lebedev@nworkstation:~$ vagrant version
Installed Version: 2.3.4
Latest Version: 2.4.0
```


## Задача 4 

*Воспроизведите практическую часть лекции самостоятельно.*

- *Создайте виртуальную машину.*
- *Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды*
```
docker ps,
```


![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/??-??/img/Screenshot_1.jpg)

