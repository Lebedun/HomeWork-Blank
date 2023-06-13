# Домашнее задание к занятию "Git" - Лебедев Антон

**Задание 1: В чём разница между:**

 - полным резервным копированием,
 - дифференциальным резервным копированием,
 - инкрементным резервным копированием.

Полное резервное копирование создаёт независимую копию данных для восстановления при каждом бэкапе. Просто, надёжно, ресурсозатратно.

Дифференциальное резервное копирование создаёт "стартовую" (полную) копию данных и затем каждая операция бэкапа записывает разницу между ней и текущим состоянием резервируемых данных. Для восстановления потребуются первая полная копия и дифференциальная на желаемый момент. На практике полная копия раз в определённое время создаётся заново, иначе в какой-то момент её отличие от текущего состояния реальных данных будет сравнимо с размером самих данных, что сведёт на нет все преимущества дифференциальной схемы.

Инкрементное резервное копирование использует аналогичную схему, но записываются каждый раз изменения не с момента создания предыдущей полной копии, а с момента любого предыдущего бэкапа. Таким образом, для восстановления потребуются ВСЕ бэкапы, начиная с последней полной копии. Потеря любого бэкапа сделает невозможным восстановление на любой момент начиная с утерянной инкрементной копии и до следующей полной. Необходимость регулярно делать полные копии заново ещё очевиднее, чем в предыдущем случае.

**Задание 2: Установите программное обеспечении Bacula, настройте bacula-dir, bacula-sd, bacula-fd. Протестируйте работу сервисов.**

Чтобы не делать ответ нечитабельным, привожу только ключевые секции конфигурационных файлов, которые я менял сам. 

bacula-dir.conf:
```````
Storage { 
  Name = DWorkstation-sd
  SDPort = 9103
  Address = 127.0.0.1
  Password = "MhtWfcxCoDV-QO4E55KWYxtwEgJEq36OB"
  Device = FileChgr1-Dev1 # Вот на этой строчке я ОЧЕНЬ сильно погорел.
# Почти во всех примерах, что мне попадались в сети, имена Storage и Device совпадают,
# ну и я не посмотрел, что у меня они разные... За ошибку конфигурации это не считается
# и служба стартует, а бэкап не запускается... Пока разобрался, что не так...
  Media Type = File
}
 
JobDefs { # Менял только пару параметров, остальные пропускаю
  FileSet = "Test Set"
  Schedule = "TestShedule"
}
Job {
  Name = "TestBackup"
  JobDefs = "DefaultJob"
}
Job {
  Name = "RestoreFiles"
  Type = Restore
  Client=DWorkstation-fd
  Storage = DWorkstation-sd
  FileSet="Test Set"
  Pool = File
  Messages = Standard
  Where = /home/lebedev/10-04/restore
}
FileSet {
  Name = "Test Set"
  Include {
    Options {
      signature = MD5
    }
   File = /home/lebedev/10-04/sample # Трогать /etc не решился
  }
}
Schedule {
  Name = "TestShedule"
  Run = Full daily at 22:26 # Был шокирован невозможностью запустить задание принудительно, для тестов пришлось подкручивать расписание под запуск через минуту. 
}

Director { # Ничего не менял, пропускаю
}
Client { # Ничего не менял, пропускаю
}
Catalog { # Ничего не менял, пропускаю
}
Messages { # Ничего не менял, пропускаю
}
Pool { # Ничего не менял, пропускаю
}
Console { # Ничего не менял, пропускаю
}
```````

bacula-sd.conf:
```````
Storage {                        
  Name = DWorkstation-sd
  SDPort = 9103                 
  WorkingDirectory = "/var/lib/bacula"
  Pid Directory = "/run/bacula"
  Plugin Directory = "/usr/lib/bacula"
  Maximum Concurrent Jobs = 20
  SDAddress = 127.0.0.1
}

Device {
  Name = FileChgr1-Dev1
  Media Type = File
  Archive Device = /home/lebedev/10-04/backup
  LabelMedia = yes;                   
  Random Access = Yes;
  AutomaticMount = yes;
  RemovableMedia = no;
  AlwaysOpen = no;
  Maximum Concurrent Jobs = 5
}

Director { # Ничего не менял, пропускаю
}
Messages { # Ничего не менял, пропускаю
}
```````
bacula-sd.conf:
```````
# Вообще не редактировал этот файл, пропускаю
```````

В итоге попытки с пятнадцатой задача наконец отработала:
![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/10-04/img/Screenshot_1.jpg)
![Screenshot_2](https://github.com/Lebedun/HomeWork-Blank/blob/10-04/img/Screenshot_2.jpg)

**Задание 3: Установите программное обеспечении Rsync. Настройте синхронизацию на двух нодах. Протестируйте работу сервиса.**

Практически ничего менять не пришлось (даже IP совпал), только папку указал тестовую.

На первом узле: rsyncd.conf
```````
pid file = /var/run/rsyncd.pid
log file = /var/log/rsyncd.log
transfer logging = true
munge symlinks = yes
[data]
path = /home/lebedev/10-04
uid = root
read only = yes
list = yes
comment = Data backup Dir
auth users = backup
secrets file = /etc/rsyncd.scrt
```````

На втором узле: backup-node1.sh
```````
#!/bin/bash
date
syst_dir=/home/lebedev/10-04/
srv_name=nodeOne
# Адрес сервера, который архивируем
srv_ip=192.168.0.1
srv_user=backup
srv_dir=data
echo "Start backup ${srv_name}"
mkdir -p ${syst_dir}${srv_name}/increment/
/usr/bin/rsync -avz --progress --delete --password-file=/etc/rsyncd.scrt ${srv_user}@${srv_ip}::${srv_dir} ${syst_dir}${srv_name}/current/ --backup --backup-dir=${syst_dir}${srv_name}/increment/`d>
/usr/bin/find ${syst_dir}${srv_name}/increment/ -maxdepth 1 -type d -mtime +30 -exec rm -rf {} \;
date
echo "Finish backup ${srv_name}"
```````

**Задание 4 со звёздочкой: Настройте резервное копирование двумя или более методами, используя одну из рассмотренных команд для папки /etc/default. Проверьте резервное копирование.**

Честно говоря, не понял задание 4 - ведь в предыдущих конфигах достаточно только заменить путь к исходной папке. Задания у меня реально отрабатывали, в конечной папке появлялись копии данных. Для примера запустил rsync c исходной папкой /etc/default - получил на втором узле точную её копию. Также запустил задание восстановления в bakula (удивился, почему задание restore доступно по команде run, но не работает там, и его нужно запускать через команду restore и вручную помечать восстанавливаемые объекты, ну да ладно, программа изначально была заточена под работу с ленточными накопителями и можно простить ей некоторые странности).

Собственно, настроенный бэкап - это когда данные сохранены в резервной копии и затем успешно восстановлены из неё, а уж что именно бэкапилось - сервис бэкапа волнует меньше всего... На вход ему подать можно абсолютно что угодно...

![Screenshot_3](https://github.com/Lebedun/HomeWork-Blank/blob/10-04/img/Screenshot_3.jpg)
![Screenshot_4](https://github.com/Lebedun/HomeWork-Blank/blob/10-04/img/Screenshot_4.jpg)
