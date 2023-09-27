# Домашнее задание к занятию "PostgreSQL" - Лебедев Антон

## Задача 1

*Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.*

*Подключитесь к БД PostgreSQL, используя `psql`.*

*Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.*

***Найдите и приведите** управляющие команды для:*

- *вывода списка БД,*
- *подключения к БД,*
- *вывода списка таблиц,*
- *вывода описания содержимого таблиц,*
- *выхода из psql.*

---

- вывода списка БД: \l
- подключения к БД: \c имя_БД
- вывода списка таблиц: \dt
- вывода описания содержимого таблиц: - вот этого не понял. Если нужно получить список столбцов таблицы - это делается через select из таблицы information_schema.columns, а не через короткие команды.
- выхода из psql: \q


## Задача 2

*Используя `psql`, создайте БД `test_database`.*

*Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).*

*Восстановите бэкап БД в `test_database`.*

*Перейдите в управляющую консоль `psql` внутри контейнера.*

*Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.*

*Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.*

***Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.*

---

```
test_database=# select attname from pg_stats where tablename = 'orders' order by avg_width desc limit 1;
 attname
---------
 title
(1 row)
```
## Задача 3

*Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.*

*Предложите SQL-транзакцию для проведения этой операции.*

*Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?*

---

Разумеется, можно сразу раскидывать данные по двум таблицам в зависимости от параметра price, но, по-моему, такой подход в целом порождает ещё больше проблем, чем решает:

1. Всегда и везде нужно помнить о том, что таблиц две - любая операция получения данных должна получать их из обеих (особенно всякие средние будет "удобно" считать). А что будет, когда двух таблиц станет мало ? Придётся делать три. А потом, как в анекдоте про физика, решающего задачу про устойчивость стола, мы будем до пенсии писать код, работающий с произвольным числом таблиц.
2. Если параметр price меняется - надо переносить данную строку из одной таблицы в другую (ведь единственный смысл такого шардирования - это ускорить поиск по price).
3. Пограничное значение между таблицами 1 и 2 нужно или выбрать раз и навсегда (и страдать, если одна таблица в итоге станет в 10 раз больше другой и смысл в таком шардировании исчезнет), либо предусмотреть механизм перебалансировки с изменением пограничного значения.

С другой стороны, а в такой ситуации и предложить-то нечего. Индекс добавить - само собой, но, полагаю, что речь о таком размере таблицы, когда уже и индекс не справляется (представил таблицу из двух int и одного varchar(80), с которой не может справиться индекс b-tree... да сколько же там заказов-то ? Амазон лопнет от зависти). Шардировать по хешу (что даст автобалансировку) бессмысленно - пропадёт весь смысл облегчения поиска, у нас тут больше упорядочивать-то не по чему, кроме price.

```
begin;

DROP TABLE IF EXISTS public.orders_1;
CREATE TABLE public.orders_1 (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);

DROP TABLE IF EXISTS public.orders_2;
CREATE TABLE public.orders_2 (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);

INSERT INTO public.orders_1 (SELECT * FROM public.orders WHERE price>499);
INSERT INTO public.orders_2 (SELECT * FROM public.orders WHERE price<=499);

DROP TABLE public.orders;

commit;
```

## Задача 4

*Используя утилиту `pg_dump`, создайте бекап БД `test_database`.*

*Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?*

---

Не совсем понял вопрос. Уникальность значения этого столбца и в исходной таблице не гарантировалась. Если речь идёт о столбце id, чтобы в orders_1 и orders_2 не повторялись id, то проще всего к каждой таблице прикрутить свой генератор id следующего вида (скопировано из исходного дампа):

```
CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1 
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
```

И заменить стартовые значения на 1 и 2, а инкремент сделать равным 2. Тогда в одной таблице все id будут чётными, а в другой нечётными. Правда, тогда и добавлять данные в таблицу в команде COPY надо без явного указания ID, чтобы работал автоинкремент.
