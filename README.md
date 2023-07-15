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

*Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.*

COUNT(1) использую для быстродействия, чтобы запрос не доставал из таблицы ненужные поля.
```
SELECT COUNT(1) FROM sakila.film f
WHERE f.length > (SELECT AVG(f.length) FROM sakila.film f);
```


### Задание 3

*Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.*

Первый подзапрос вычисляет самый доходный месяц, второй подзапрос выдаёт общее количество аренд за каждый месяц, далее join и некоторая обработка результатов, чтобы вывести год и месяц отдельно.

```
SELECT YEAR(subs1.p_month) best_year, MONTH(subs1.p_month) best_month, subs1.p_sum total_sum, subs2.r_num total_rents FROM 
(
	SELECT EXTRACT(YEAR_MONTH FROM p.payment_date) p_month, SUM(p.amount) p_sum 
	FROM sakila.payment p 
	GROUP BY EXTRACT(YEAR_MONTH FROM p.payment_date)
	ORDER BY p_sum DESC
	LIMIT 1
) subs1
JOIN
(
	SELECT EXTRACT(YEAR_MONTH FROM r.rental_date) p_month, count(1) r_num 
	FROM sakila.rental r  
	GROUP BY EXTRACT(YEAR_MONTH FROM r.rental_date)
) subs2
ON subs1.p_month = subs2.p_month;
```


### Задание 4*

*Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».*

Ну здесь совсем всё просто.

```
SELECT s.first_name name, s.last_name lastname, COUNT(1) total,
CASE
	WHEN  COUNT(1) > 8000 THEN 'Да'
	ELSE 'Нет'
END as 'Премия'
FROM sakila.rental r 
JOIN sakila.staff s ON r.staff_id = s.staff_id 
GROUP BY r.staff_id;
```
### Задание 5*

*Найдите фильмы, которые ни разу не брали в аренду.*

Тоже несложно - сначала делаем список всех ID фильмов, которые когда-либо брались в аренду (никаких условий не нужно, условием будет сам JOIN - если фильм никогда не брался в аренду, соответствующих inventory.id не будет в таблице rental и фильм в выборку не попадёт), затем пользуемся конструкцией NOT IN.
 
```
SELECT DISTINCT (f.title) FROM sakila.film f 
WHERE f.film_id NOT IN
(
	SELECT DISTINCT (f.film_id) used FROM sakila.film f
	JOIN sakila.inventory i ON f.film_id = i.film_id 
	JOIN sakila.rental r ON r.inventory_id = i.inventory_id 
);
```
