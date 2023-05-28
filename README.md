# Домашнее задание к занятию 10.3 "Pacemaker" - Лебедев Антон
---
**Задание 1: Опишите основные функции и назначение Pacemaker.**

Pacemaker - менеджер ресурсов кластера. Его основная работа - находить и устранять сбои на уровне нодов, отключать сбойные ресурсы, обеспечивать механизмы кворума, реплицировать конфиги на различные узлы кластера и т.п.

---
**Задание 2: Опишите основные функции и назначение Corosync.**

Corosync - программный продукт, позволяющий серверам и приложениям в составе кластера "общаться" между собой, реализуя собственно концепцию кластера. К примеру, он может оповещать приложения о смене активной ноды, отправлять идентичные сообщения процессам на всех нодах, предоставлять доступ к общей БД с конфигурацией и статистикой кластера и т.д.

---
**Задание 3: Соберите модель, состоящую из двух виртуальных машин. Установите Pacemaker, Corosync, Pcs. Настройте HA кластер.**

Пустой кластер (если я правильно понял задание) собран, результат pcs status на обеих нодах прилагается. А сколько было нюансов по дороге, пока я не добился, чтобы pacemaker видел обе ноды =). 

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/10-03/img/Screenshot_1.jpg)

---
**Задание 4 (со звёздочкой): Установите и настройте DRBD-сервис для настроенного кластера.**

Вроде разобрался. Ноды синхронизировались, папки смонтировались, созданные для теста файлы со второй ноды (при отключении первой) увидел.

mysql.res
````````````````````````
resource mysql {
    protocol C;
    disk {
        fencing resource-only;
    }
    handlers {
        fence-peer
        "/usr/lib/drbd/crm-fence-peer.sh";
        after-resync-target
        "/usr/lib/drbd/crm-unfence-peer.sh";
    }
    syncer {
        rate 110M;
    }
    on Pacemaker2
    {
        device /dev/drbd0;
        disk /dev/vg0/mysql;
        address 192.168.1.2:7795;
        meta-disk internal;
    }
    on Pacemaker1
    {
        device /dev/drbd0;
        disk /dev/vg0/mysql;
        address 192.168.1.1:7795;
        meta-disk internal;
    }
}
````````````````````````

www.res
````````````````````````
resource www {
    protocol C;
    disk {
        fencing resource-only;
    }
    handlers {
        fence-peer
        "/usr/lib/drbd/crm-fence-peer.sh";
        after-resync-target
        "/usr/lib/drbd/crm-unfence-peer.sh";
    }
    syncer {
        rate 110M;
    }
    on Pacemaker2
    {
        device /dev/drbd2;
        disk /dev/vg0/www;
        address 192.168.1.2:7794;
        meta-disk internal;
    }
    on Pacemaker1
    {
        device /dev/drbd2;
        disk /dev/vg0/www;
        address 192.168.1.1:7794;
        meta-disk internal;
    }
}
````````````````````````
![Screenshot_4](https://github.com/Lebedun/HomeWork-Blank/blob/10-03/img/Screenshot_4.jpg)


---
