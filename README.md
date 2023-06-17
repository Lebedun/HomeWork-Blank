# Домашнее задание к занятию "Балансировка нагрузки. HAProxy/Nginx" - Лебедев Антон

---

**Задание 1 Что такое балансировка нагрузки и зачем она нужна?**

Балансировка нагрузки позволяет нескольким серверам вместе обрабатывать большое количество запросов таким образом, чтобы каждый из них был нагружен примерно одинаково.

---

**Задание 2 Чем отличаются алгоритмы балансировки Round Robin и Weighted Round Robin? В каких случаях каждый из них лучше применять?**

В алгоритм Weighed Round Robin добавлен "вес" сервера, который позволяет направлять больше запросов более мощным серверам. Полезен в тех случаях, когда сервера не одинаковы по своей "пропускной способности".

---

**Задание 3 Установите и запустите Haproxy. Приведите скриншот systemctl status haproxy, где будет видно, что Haproxy запущен.**

![Screenshot_1](https://github.com/lebedun/HomeWork-Blank/blob/10-05/img/Screenshot_1.jpg)

---

**Задание 4 Установите и запустите Nginx. Приведите скриншот systemctl status nginx, где будет видно, что Nginx запущен.**

![Screenshot_2](https://github.com/lebedun/HomeWork-Blank/blob/10-05/img/Screenshot_2.jpg)

---

**Задание 5 Настройка Nginx**

*Настройте Nginx на виртуальной машине таким образом, чтобы при запросе:*

*curl http://localhost:8088/ping*

*он возвращал в ответе строчку:*

*"nginx is configured correctly".*

*Приведите конфигурации настроенного Nginx сервиса и скриншот результата выполнения команды curl http://localhost:8088/ping.*

``````````
user  nginx;
worker_processes  auto;
error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
  server {
    listen 8088;
    location /ping {
      return 200 'nginx is configured correctly\n';
    }
  }
}
``````````

![Screenshot_3](https://github.com/lebedun/HomeWork-Blank/blob/10-05/img/Screenshot_3.jpg)

---

**Задание 6\* Настройка Haproxy**

*Настройте Haproxy таким образом, чтобы при ответе на запрос:*

*curl http://localhost:8080/*

*он проксировал его в Nginx на порту 8088, который был настроен в задании 5 и возвращал от него ответ:*

*"nginx is configured correctly".*

*Приведите конфигурации настроенного Haproxy и скриншоты результата выполнения команды curl http://localhost:8080/*.

---
