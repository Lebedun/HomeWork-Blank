# Домашнее задание к занятию "GitLab" - Лебедев Антон

**Задание 1 - настройка gitlab-runner**

```````````````````````
concurrent = 1
check_interval = 0
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "run-01"
  url = "http://51.250.81.134/"
  id = 4
  token = "6cc4F7QTs1QAq993ipze"
  token_obtained_at = 2023-05-15T21:13:12Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "docker"
  [runners.cache]
    MaxUploadedArchiveSize = 0
  [runners.docker]
    tls_verify = false
    image = "go:1.17"
    privileged = false
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
    shm_size = 0
```````````````````````

**Задание 2 - сборка проекта**

Тут я дал маху - когда создавал ВМ с гитлабом, выделил ей диск по умолчанию, и на этапе сборки проекта место кончилось. Для увеличения диска ВМ пришлось перезагрузить, и она получила новый IP. Сначала я думал, что удастся отделаться сменой конфига раннера и заменой параметров в origin, но в итоге пришлось переделывать всё целиком - после reconfigure раннер проще оказалось создать с нуля.

Файл сборки не изменился:

```````````````````````
stages:
  - test
  - build

test:
  stage: test
  image: golang:1.17
  script:
   - go test .

build:
  stage: build
  image: docker:latest
  script:
   - docker build .
```````````````````````

Скриншот результата сборки:

![Screenshot_1](https://github.com/Lebedun/HomeWork-Blank/blob/main/img/Screenshot_1.jpg)
