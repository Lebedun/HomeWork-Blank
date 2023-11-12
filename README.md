# Домашнее задание к занятию "???" - Лебедев Антон

## Задача 1

*Дайте письменые ответы на вопросы:*

- *В чём отличие режимов работы сервисов в Docker Swarm-кластере: replication и global?*

global - копия сервиса запускается на каждой ноде (самый распространённый пример - агент мониторинга).
replicated - запускается фиксированное количество реплик, распределяемых между нодами.

- *Какой алгоритм выбора лидера используется в Docker Swarm-кластере?*

 Raft Consensus Algorithm
  
- *Что такое Overlay Network?*

Сеть, объединяющая хосты Docker Swarm и позволяющая контейнерам, расположенным на разных хостах, обмениваться информацией.

## Задача 2

*Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.*

*Чтобы получить зачёт, предоставьте скриншот из терминала (консоли) с выводом команды:*
```
docker node ls
```

## Задача 3

*Создайте ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.*

*Чтобы получить зачёт, предоставьте скриншот из терминала (консоли), с выводом команды:*
```
docker service ls
```

## Задача 4 (*)

*Выполните на лидере Docker Swarm-кластера команду, указанную ниже, и дайте письменное описание её функционала — что она делает и зачем нужна:*
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```



![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/??-??/img/Screenshot_1.jpg)

