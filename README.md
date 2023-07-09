# Домашнее задание к занятию "Работа с данными (DDL/DML)" - Лебедев Антон
### Задание 1

1.1. Поднимите чистый инстанс MySQL версии 8.0+. Можно использовать локальный сервер или контейнер Docker.

1.2. Создайте учётную запись sys_temp. 

1.3. Выполните запрос на получение списка пользователей в базе данных. (скриншот)

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/12-02/img/Screenshot_1.jpg)

1.4. Дайте все права для пользователя sys_temp. 

1.5. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

В итоге, чтобы подключиться с основной машины (где был установлен DBeaver) через проброшенный порт в виртуалку, пришлось создать пользователя sys_temp@% с аналогичным уровнем прав.

```
CREATE USER 'sys_temp'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'localhost' WITH GRANT OPTION;
CREATE USER 'sys_temp'@'%' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON *.* TO 'sys_temp'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

Скриншот обрезал, так как там очень длинный список прав.

![Screenshot_2](https://github.com/Lebedun/HomeWork-Blank/blob/12-02/img/Screenshot_2.jpg)

1.6. Переподключитесь к базе данных от имени sys_temp.

1.6.1 По ссылке https://downloads.mysql.com/docs/sakila-db.zip скачайте дамп базы данных.

1.7. Восстановите дамп в базу данных.

На удивление просто оказалось всё. Скачал - распаковал - создал схему - загрузил данные. Я думал будет больше мороки.

```
wget https://downloads.mysql.com/docs/sakila-db.zip
unzip sakila-db.zip
cd sakila-db/
mysql -u sys_temp -p < sakila-schema.sql
mysql -u sys_temp -p < sakila-data.sql
```

1.8. При работе в IDE сформируйте ER-диаграмму получившейся базы данных. При работе в командной строке используйте команду для получения всех таблиц базы данных. (скриншот)



![Screenshot_3](https://github.com/Lebedun/HomeWork-Blank/blob/12-02/img/Screenshot_3.jpg)


### Задание 2
Составьте таблицу, используя любой текстовый редактор или Excel, в которой должно быть два столбца: в первом должны быть названия таблиц восстановленной базы, во втором названия первичных ключей этих таблиц. 
```
Название таблицы    | Название первичного ключа
actor               | actor_id
address             | address_id
category            | category_id
city                | city_id
country             | country_id
customer            | customer_id
film                | film_id
film_actor          | actor_id, film_id (составной ключ)
film_category       | film_id, category_id (составной ключ)
film_text           | film_id
inventory           | inventory_id
language            | language_id
payment             | payment_id
rental              | rental_id
staff               | staff_id
store               | store_id
```

### Задание 3*
3.1. Уберите у пользователя sys_temp права на внесение, изменение и удаление данных из базы sakila.

Поскольку мы создавали пользователя до БД и давали ему полные права на все БД, то мы можем либо удалить его права полностью и дать права заново только нужные и только на базу sakila, либо провернуть подобную команду (всё равно на сервере у нас только одна база данных):

```
REVOKE INSERT, DELETE, CREATE, ALTER, UPDATE, DROP, CREATE TEMPORARY TABLES, LOCK TABLES, CREATE VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE, SHUTDOWN ON *.* FROM 'sys_temp'@'%';
```

3.2. Выполните запрос на получение списка прав для пользователя sys_temp. (скриншот)

Останутся только права вроде таких (возможно, стоило выкинуть ещё что-то):

![Screenshot_4](https://github.com/Lebedun/HomeWork-Blank/blob/??-??/img/Screenshot_4.jpg)

