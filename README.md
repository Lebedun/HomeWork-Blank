# Домашнее задание к занятию "SQL. Часть 2" - Лебедев Антон

### Задание 1

*Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию:* 
*- фамилия и имя сотрудника из этого магазина;*
*- город нахождения магазина;*
*- количество пользователей, закреплённых в этом магазине.*

Сначала придумал так:
``` 
SELECT st.first_name, st.last_name, c.city, subs2.c_num#,
#s.store_id, s.manager_staff_id, s.address_id, a.city_id  
FROM sakila.store s 
JOIN sakila.staff   st ON s.manager_staff_id = st.staff_id
JOIN sakila.address a  ON s.address_id = a.address_id
JOIN sakila.city    c  ON a.city_id  = c.city_id
JOIN 
(
	SELECT c.store_id id, COUNT(store_id) c_num FROM sakila.customer c GROUP BY store_id
) subs2 
                      ON subs2.id = s.store_id
#
#
WHERE s.store_id IN 
(
	SELECT subs1.id FROM 
	(
		SELECT c.store_id id, COUNT(store_id) c_num FROM sakila.customer c GROUP BY store_id
	) subs1
	where subs1.c_num > 300
);

```
Потом дошло, что делал я задачу "от простого к сложному", но в конце подзапрос 1 стал не нужен, надо просто вытащить в подзапросе 2 ещё одно поле.

```
SELECT st.first_name, st.last_name, c.city, subs2.c_num  
FROM sakila.store s 
JOIN sakila.staff   st ON s.manager_staff_id = st.staff_id
JOIN sakila.address a  ON s.address_id = a.address_id
JOIN sakila.city    c  ON a.city_id  = c.city_id
JOIN 
(
	SELECT c.store_id id, COUNT(store_id) c_num FROM sakila.customer c GROUP BY store_id
) subs2 
                      ON subs2.id = s.store_id
WHERE subs2.c_num > 300;
```
Отмечу, что здесь предполагается, что все таблицы заполнены корректно и у нас, например, в address_id не вылезет NULL, который нужно обрабатывать отдельно.

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».

### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/??-??/img/Screenshot_1.jpg)

