# Домашнее задание к занятию "Базы данных, их типы" - Лебедев Антон

**Задание 1. СУБД**

Кейс

Крупная строительная компания, которая также занимается проектированием и девелопментом, решила создать правильную архитектуру для работы с данными. Ниже представлены задачи, которые необходимо решить для каждой предметной области.

Какие типы СУБД, на ваш взгляд, лучше всего подойдут для решения этих задач и почему?

1.1. Бюджетирование проектов с дальнейшим формированием финансовых аналитических отчётов и прогнозирования рисков. СУБД должна гарантировать целостность и чёткую структуру данных.

Целостность и чёткая структура данных - характерная особенность SQL-баз. 

1.1.* Хеширование стало занимать длительно время, какое API можно использовать для ускорения работы?

Не совсем понял вопрос. Если c поиском в базе не справляется метод хеширования, значит, нужно использовать b-tree, но при чём тут API ? 

1.2. Под каждый девелоперский проект создаётся отдельный лендинг, и все данные по лидам стекаются в CRM к маркетологам и менеджерам по продажам. Какой тип СУБД лучше использовать для лендингов и для CRM? СУБД должны быть гибкими и быстрыми.

Данные требования подразумевают применение NoSQL СУБД.

1.2.* Можно ли эту задачу закрыть одной СУБД? И если да, то какой именно СУБД и какой реализацией?

MongoDB всё равно единственная СУБД такого класса, которая постоянно на слуху у тех, кто не занимается подобными вещами плотно, так что назову её.

1.3. Отдел контроля качества решил создать базу по корпоративным нормам и правилам, обучающему материалу и так далее, сформированную согласно структуре компании. СУБД должна иметь простую и понятную структуру.

Вот людям, которые будут заниматься этой работой, лучше вообще не морочить голову словами "база данных", они обычно менеджеры, а не айтишники. Поставить им любой вики-движок (например, Confluence), и будет им счастье. Нагрузку, которую они смогут создать, вывезет абсолютно любая БД (по условиям задачи мы крупная компания и можем выделить этом отделу нормальную ВМ под их сервер), поэтому тут главным критерием в выборе решения будет выступать не простота базы данных, а простота использования решения конечными пользователями.

1.3.* Можно ли под эту задачу использовать уже существующую СУБД из задач выше и если да, то как лучше это реализовать?

Можно, конечно, разместить отдельную базу вики-движка на том же сервере БД, где расположена база отдела бюджетирования, но я лично сомневаюсь в правильности подхода "положить все яйца в одну корзинку", когда речь идёт о крупной строительной компании. Изоляция подобных сервисов друг от друга ещё никому не вредила.

1.4. Департамент логистики нуждается в решении задач по быстрому формированию маршрутов доставки материалов по объектам и распределению курьеров по маршрутам с доставкой документов. СУБД должна уметь быстро работать со связями.

Тут отмечу, что "задача коммивояжёра" всё же NP-полная, и её решение (пусть даже приближённое) упрётся не в скорость работы СУБД (из базы нужно будет один раз получить данные, по которым пойдёт трудоёмкий расчёт), а в производительность вычислительной системы. Поэтому базу данных можно использовать произвольную, от неё мало что зависит.

1.4.* Можно ли к этой СУБД подключить отдел закупок или для них лучше сформировать свою СУБД в связке с СУБД логистов?

С учётом ответа на предыдущий вопрос - думаю, без проблем. Сильно нагруженной эта СУБД не будет.

1.5.* Можно ли все перечисленные выше задачи решить, используя одну СУБД? Если да, то какую именно?

Нет. В некоторых пунктах противоположны требования к СУБД, плюс банальные соображения по изоляции сервисов с целью повышения отказоустойчивости.

**Задание 2. Транзакции**

2.1. Пользователь пополняет баланс счёта телефона, распишите пошагово, какие действия должны произойти для того, чтобы транзакция завершилась успешно. Ориентируйтесь на шесть действий.

1. Проверка реквизитов платежа (убеждаемся, что данные для транзакции корректны).
2. Проверка, что необходимая сумма есть (и не заблокирована) на счету пользователя.
3. Блокировка необходимой суммы на счету пользователя.
4. Обращение в банковскую систему для перевода денег.
5. Получение сообщения об успешном совершении операции (тут от пользователя может потребоваться дополнительное подтверждение).
6. Списание заблокированной суммы со счёта пользователя.

2.1.* Какие действия должны произойти, если пополнение счёта телефона происходило бы через автоплатёж?

Всё то же самое, только подтверждение каждый раз у пользователя запрашиваться не будет, а в случае неуспешной операции пользователя нужно дополнительно оповестить другим методом о неудаче.

**Задание 3. SQL vs NoSQL**

3.1. Напишите пять преимуществ SQL-систем по отношению к NoSQL.

Лучшая масштабируемость в самых разных смыслах (от увеличения числа узлов до увеличения производительности одного узла)
Высокая доступность (за счёт простоты масштабируемости)
Простое изменение структуры базы
Высокая производительность
Возможность хранения больших объёмов неструктурированной информации (беда SQL-баз).

3.1.* Какие, на ваш взгляд, преимущества у NewSQL систем перед SQL и NoSQL.

Вышеперечисленные преимущества NoSQL плюс транзакционные требования (атомарность, согласованность, изоляция, устойчивость).

**Задание 4. Кластеры**

Необходимо производить большое количество вычислений при работе с огромным количеством данных, под эту задачу выделено 1000 машин.

На основе какого критерия будете выбирать тип СУБД и какая модель распределённых вычислений здесь справится лучше всего и почему?

Всё зависит от того, можно ли эффективно разбить задачу на "независимые" блоки по макроконвейерному принципу (практическая реализация - грид-вычисления) - то есть, построить вычисления так, чтобы каждая из машин могла больше времени тратить на собственно вычисления над теми данными, что у неё уже есть, чем на обмен обновлёнными данными с соседними машинами для выполнения следующего "шага" вычислений. Если задачу можно очень эффективно разбить на почти не взаимодействующие блоки, подойдёт распределённая СУБД, "своя" часть которой будет храниться на каждой машине. Если такое невозможно - увы, очень много времени придётся тратить на репликацию, и тут, наверное лучше справится централизованная СУБД, способная выдавать короткие "задания" отдельным узлам, сама занимаясь сборкой полученных от них результатов воедино.

Конкретный тип хранения информации в базе, пожалуй, также зависит от типа задачи. Из знакомых мне задач, где возможно применение распределённых вычислений (я по образованию физик), обычно данные - это вещественные значения, расположенные в узлах огромного графа, так что, видимо, там подошла бы графовая СУБД. Но не сомневаюсь, что для других конкретных задач могут оказаться оптимальными другие типы СУБД.

