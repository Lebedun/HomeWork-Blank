# Домашнее задание к занятию 10.3 "Pacemaker" - Лебедев Антон
---
**Задание 1: Опишите основные функции и назначение Pacemaker.**

---
**Задание 2: Опишите основные функции и назначение Corosync.**

---
**Задание 3: Соберите модель, состоящую из двух виртуальных машин. Установите Pacemaker, Corosync, Pcs. Настройте HA кластер.**

---
**Задание 4* Установите и настройте DRBD-сервис для настроенного кластера.**

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
