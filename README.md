# Домашнее задание к занятию "Индексы" - Лебедев Антон

### Задание 1

*Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.*

```sql
SELECT SUM(INDEX_LENGTH)/(SUM(DATA_LENGTH)+SUM(INDEX_LENGTH))*100
FROM information_schema.TABLES
WHERE table_schema = "sakila";
```

### Задание 2

*Выполните explain analyze следующего запроса:*
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
*- перечислите узкие места;*
*- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.*

Тут у меня волосы встали дыбом глядя на запрос без всякого explain analyse. Прямое произведение пяти таблиц, две из которых (inventory и film) реально вообще не используется ?! 

Причёсываем запрос к следующему виду:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id)
from sakila.payment p 
join sakila.rental r ON p.payment_date = r.rental_date 
join sakila.customer c ON r.customer_id = c.customer_id 
where date(p.payment_date) = '2005-07-30';
```

и затем заменяем partition by на group by, выбрасывая distinct:
```sql
select concat(c.last_name, ' ', c.first_name), sum(p.amount)
from sakila.payment p 
join sakila.rental r ON p.payment_date = r.rental_date 
join sakila.customer c ON r.customer_id = c.customer_id 
where date(p.payment_date) = '2005-07-30'
GROUP BY c.customer_id; 
```
И запрос выполняется за 21 миллисекунду, explain analysе на таких объёмах данных применять просто некуда. Если очень хочется, можно добавить в таблицу payment индекс по полю payment.date, это единственное, что может реально ускорить поиск, но тогда условие where лучше переписать так: 
```sql
where p.payment_date > '2005-07-30 00:00:00' and p.payment_date < '2005-07-30 23:59:59'
```
чтобы избежать лишних вызовов функции date. Пробовал вместо этой конструкции с двумя сравнениями использовать BETWEEN - результат получился хуже.

Наиболее оптимизированный запрос в итоге отрабатывает за 11-15 миллисекунд (время каждый раз разное).

### Задание 3*

*Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.*

В PostgreSQL присутствуют следующие типы индексов, которых нет в MySQL:
 - Bitmap index (битовая "карта" расположения конкретного значения в столбце, хорошо работает для столбцов, где возможное число значений мало).
 - Partial index (построен на части таблицы, удовлетворяющей некому условию, применяется для уменьшения размера индекса).
 - Function based index (ключи этого индекса строятся с помощью заданной пользователем функции).
