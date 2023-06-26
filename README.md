# Домашнее задание к занятию "ELK" - Лебедев Антон

Уфф. Смог найти только 8 версию elasticsearch, а там по сравнению с 7, которая была на лекции, отключили анонимуса и больше нет http (только https). В некоторых моментах это слегка поднапрягло =).

---

### Задание 1. Elasticsearch 

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный. 

*Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере с установленным Elasticsearch. Где будет виден нестандартный cluster_name*.

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/11-03/img/Screenshot_1.jpg)

---

### Задание 2. Kibana

Установите и запустите Kibana.

*Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, где будет выполнен запрос GET /_cluster/health?pretty*.

![Screenshot_2](https://github.com/Lebedun/HomeWork-Blank/blob/11-03/img/Screenshot_2.jpg)

---

### Задание 3. Logstash

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.*

![Screenshot_3](https://github.com/Lebedun/HomeWork-Blank/blob/11-03/img/Screenshot_3.jpg)

---

### Задание 4. Filebeat. 

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat. 

*Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.*

Ненавижу yaml ! Два часа искал два потерянных пробела в конфиге =))).

![Screenshot_4](https://github.com/Lebedun/HomeWork-Blank/blob/11-03/img/Screenshot_4.jpg)
