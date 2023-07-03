# Домашнее задание к занятию "Базы данных" - Лебедев Антон

### Задание 1

Опишите не менее семи таблиц, из которых состоит база данных:

- какие данные хранятся в этих таблицах;
- какой тип данных у столбцов в этих таблицах, если данные хранятся в PostgreSQL.

Сотрудники (
- идентификатор, первичный ключ, serial,
- ФИО varchar(255),
- оклад integer,
- идентификатор должности, внешний ключ, integer,
- идентификатор структурного подразделения, внешний ключ, integer,
- идентификатор филиала, внешний ключ, integer,
- дата найма, date).

Должности (
- идентификатор, первичный ключ, serial,
- наименование, varchar(255)).

Типы структурных подразделений (
- идентификатор, первичный ключ, serial,
- наименование, varchar(255))

Структурные подразделения (
- идентификатор, первичный ключ, serial,
- идентификатор типа структурного подразделения, внешний ключ, integer,
- наименование, varchar(255))

Филиалы (
- идентификатор, первичный ключ, serial,
- адрес, varchar(1024))

Проекты (
- идентификатор, первичный ключ, serial,
- наименование, varchar(255))

 Распределение сотрудников по проектам (
 - идентификатор сотрудника, внешний ключ, integer,
 - идентифкатор проекта, внешний ключ, integer) 


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.


### Задание 2*

Перечислите, какие, на ваш взгляд, в этой денормализованной таблице встречаются функциональные зависимости и какие правила вывода нужно применить, чтобы нормализовать данные.
