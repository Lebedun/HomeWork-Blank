# Домашнее задание к занятию "SQL. Часть 1" - Лебедев Антон


### Задание 1

*Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.*

```
SELECT DISTINCT district FROM sakila.address WHERE district LIKE 'K%a' AND district NOT LIKE '% %';
```
![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/12-03/img/Screenshot_1.jpg)

### Задание 2

*Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.*

Поскольку не указано, какую именно информацию получить, делаю SELECT *, поскольку выборка ограничена по датам - сортирую по ним.

```
SELECT * FROM sakila.payment p
WHERE p.amount > 10
  AND p.payment_date BETWEEN '2005-06-15 00:00:00'
  AND '2005-06-18 23:59:59'
ORDER BY p.payment_date;
```
![Screenshot_2](https://github.com/Lebedun/HomeWork-Blank/blob/12-03/img/Screenshot_2.jpg)


### Задание 3

*Получите последние пять аренд фильмов.*

Добавил дополнительную сортировку, так как в таблице много аренд с одинаковой датой: последними разумно считать те, у которых больше ключ.

```
SELECT * FROM sakila.rental r ORDER BY r.rental_date DESC, r.rental_id DESC LIMIT 5;
```
![Screenshot_3](https://github.com/Lebedun/HomeWork-Blank/blob/12-03/img/Screenshot_3.jpg)

### Задание 4

*Одним запросом получите активных покупателей, имена которых Kelly или Willie.* 

*Сформируйте вывод в результат таким образом:*
- *все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,*
- *замените буквы 'll' в именах на 'pp'.*

```
SELECT REPLACE (LOWER (first_name), 'll', 'pp') AS fn,
       LOWER(last_name) AS ln
FROM sakila.customer c
WHERE c.first_name LIKE 'Kelly' or c.first_name LIKE 'Willie';
```
![Screenshot_4](https://github.com/Lebedun/HomeWork-Blank/blob/12-03/img/Screenshot_4.jpg)

### Задание 5*

*Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.*

```
SELECT SUBSTR(s.email, 1, POSITION('@' IN s.email)-1) email,
       SUBSTR(s.email, POSITION('@' IN s.email)+1) email2
FROM sakila.customer s;
```
![Screenshot_5](https://github.com/Lebedun/HomeWork-Blank/blob/12-03/img/Screenshot_5.jpg)

### Задание 6*

*Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.*

Тут, конечно, можно было и без подзапроса обойтись, но с подзапросом как-то понятнее и эффективнее.

```
SELECT CONCAT(UPPER(LEFT(e_d.email1,1)),LOWER(SUBSTR(e_d.email1,2))) e1,
       CONCAT(UPPER(LEFT(e_d.email2,1)),LOWER(SUBSTR(e_d.email2,2))) e2
FROM 
(
	SELECT SUBSTR(s.email, 1, POSITION('@' IN s.email)-1)  email1,
	       SUBSTR(s.email, POSITION('@' IN s.email)+1) email2
	FROM sakila.customer AS s
) e_d;
```
![Screenshot_6](https://github.com/Lebedun/HomeWork-Blank/blob/12-03/img/Screenshot_6.jpg)

