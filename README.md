# Домашнее задание к занятию "???" - Лебедев Антон

## Задача 1

*Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.*

*Приведите получившуюся команду или docker-compose-манифест.*

---

Создаю 2 volume:

```
docker volume create db
docker volume create backup
```
Скачиваю нужную версию postgres и разворачиваю контейнер:

```
docker pull postgres:12.10
docker run -itd -e POSTGRES_USER=leb -e POSTGRES_PASSWORD=pwd -p 5432:5432 -v db:/var/lib/pgsql/data -v backup:/backup --name postgresql postgres:12.10
```

Скачиваю и разворачиваю вспомогательный контейнер с pgadmin:

```
docker pull dpage/pgadmin4:latest
docker run --name pgadmin-leb -p 5051:80 -e "PGADMIN_DEFAULT_EMAIL=lebedun@gmail.com" -e "PGADMIN_DEFAULT_PASSWORD=lebpwd123" -d dpage/pgadmin4
```

## Задача 2

*В БД из задачи 1:* 

- *создайте пользователя test-admin-user и БД test_db;*
- *в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);*
- *предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;*
- *создайте пользователя test-simple-user;*
- *предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.*

*Таблица orders:*

- *id (serial primary key);*
- *наименование (string);*
- *цена (integer).*

*Таблица clients:*

- *id (serial primary key);*
- *фамилия (string);*
- *страна проживания (string, index);*
- *заказ (foreign key orders).*

*Приведите:*

- *итоговый список БД после выполнения пунктов выше;*
- *описание таблиц (describe);*
- *SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;*
- *список пользователей с правами над таблицами test_db.*

---

Cписок БД:
```
test_db=# \l
                                 List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    |     Access privileges
-----------+-------+----------+------------+------------+---------------------------
 leb       | leb   | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | leb   | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | leb   | UTF8     | en_US.utf8 | en_US.utf8 | =c/leb                   +
           |       |          |            |            | leb=CTc/leb
 template1 | leb   | UTF8     | en_US.utf8 | en_US.utf8 | =c/leb                   +
           |       |          |            |            | leb=CTc/leb
 test_db   | leb   | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/leb                  +
           |       |          |            |            | leb=CTc/leb              +
           |       |          |            |            | "test-admin-user"=CTc/leb
(5 rows)
```
Описание таблицы orders:
```
test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          |
 цена         | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

Описание таблицы clients:
```
test_db=# \d clients
                                  Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default
-------------------+---------+-----------+----------+-------------------------------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | text    |           |          |
 страна проживания | text    |           |          |
 заказ             | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

Запрос на просмотр прав пользователей на таблицы orders и clients и результат его работы:
```
test_db=#  SELECT * FROM information_schema.table_privileges where table_name='clients' or table_name='orders' order by grantee;
 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 leb     | leb              | test_db       | public       | orders     | INSERT         | YES          | NO
 leb     | leb              | test_db       | public       | orders     | SELECT         | YES          | YES
 leb     | leb              | test_db       | public       | orders     | UPDATE         | YES          | NO
 leb     | leb              | test_db       | public       | orders     | DELETE         | YES          | NO
 leb     | leb              | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 leb     | leb              | test_db       | public       | orders     | REFERENCES     | YES          | NO
 leb     | leb              | test_db       | public       | orders     | TRIGGER        | YES          | NO
 leb     | leb              | test_db       | public       | clients    | INSERT         | YES          | NO
 leb     | leb              | test_db       | public       | clients    | SELECT         | YES          | YES
 leb     | leb              | test_db       | public       | clients    | UPDATE         | YES          | NO
 leb     | leb              | test_db       | public       | clients    | DELETE         | YES          | NO
 leb     | leb              | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 leb     | leb              | test_db       | public       | clients    | REFERENCES     | YES          | NO
 leb     | leb              | test_db       | public       | clients    | TRIGGER        | YES          | NO
 leb     | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 leb     | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 leb     | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 leb     | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 leb     | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 leb     | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 leb     | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 leb     | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 leb     | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 leb     | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 leb     | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 leb     | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 leb     | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 leb     | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 leb     | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 leb     | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 leb     | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 leb     | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 leb     | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 leb     | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 leb     | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 leb     | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
(36 rows)
```
## Задача 3

*Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:*

*Таблица orders*

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

*Таблица clients*

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

*Используя SQL-синтаксис:*
- *вычислите количество записей для каждой таблицы.*

*Приведите в ответе:*

    - *запросы,*
    - *результаты их выполнения.*

---

Заполнение таблиц:
```
test_db=# insert into orders ("наименование", "цена") values ('Шоколад',10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
INSERT 0 5
test_db=# insert into clients ("фамилия", "страна проживания") values ('Иванов Иван Иванович', 'USA'), ('Петров Пётр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
INSERT 0 5
```
Размер таблиц:
```
test_db=# select count (1) from orders;
 count
-------
     5
(1 row)

test_db=# select count (1) from clients;
 count
-------
     5
(1 row)

```

## Задача 4

*Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.*

*Используя foreign keys, свяжите записи из таблиц, согласно таблице:*

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

*Приведите SQL-запросы для выполнения этих операций.*

*Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.*

*Подсказка: используйте директиву `UPDATE`.*

---

Вносим данные:
```
update clients set "заказ" = (select id from orders where "наименование" = 'Книга') where ("фамилия" = 'Иванов Иван Иванович');
update clients set "заказ" = (select id from orders where "наименование" = 'Монитор') where ("фамилия" = 'Петров Пётр Петрович');
update clients set "заказ" = (select id from orders where "наименование" = 'Гитара') where ("фамилия" = 'Иоганн Себастьян Бах');
```

Получаем список клиентов:
```
test_db=# select "фамилия" from clients where "заказ" is not null;
       фамилия
----------------------
 Иванов Иван Иванович
 Петров Пётр Петрович
 Иоганн Себастьян Бах
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---


![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/??-??/img/Screenshot_1.jpg)

