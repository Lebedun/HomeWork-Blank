# Домашнее задание к занятию 10.1 «Keepalived/vrrp» - Лебедев Антон

**Задание 1: Разверните топологию из лекции и выполните установку и настройку сервиса Keepalived.**

Делал в Яндекс.Облаке, поэтому немного странные ip-адреса (сначала создал ВМ в дефолтной подсети и потом поменял подсеть на свою, IP яндекс назначил сам).

Нода 1:
``````````````
vrrp_instance failover_test {
state MASTER
interface eth0
virtual_router_id 10
priority 110
advert_int 4
authentication {
auth_type AH
auth_pass 1111
}
unicast_peer {
192.168.0.24
}
  virtual_ipaddress {
  192.168.0.10/16 dev eth0 label eth0:vip
}
}
``````````````
Нода 2:
``````````````
vrrp_instance failover_test {
state BACKUP
interface eth0
virtual_router_id 10
priority 100
advert_int 4
authentication {
auth_type AH
auth_pass 1111
}
unicast_peer {
192.168.0.20
}
  virtual_ipaddress {
  192.168.0.10/16 dev eth0 label eth0:vip
}
}
``````````````
![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/10-01/img/Screenshot_1.jpg)
![Screenshot_2](https://github.com/Lebedun/HomeWork-Blank/blob/10-01/img/Screenshot_2.jpg)


