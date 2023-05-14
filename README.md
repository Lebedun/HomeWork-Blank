# Домашнее задание к занятию "Что такое DevOps. СI/СD" - Лебедев Антон

**Задание 1 : установка jenkins и сборка проекта вплоть до docker build **

Jenkins не устанавливал, локальная машина слабовата. Использовал облачную ВМ с предустановленым Jenkins, туда добавил go и docker.

Настройки идентичны тем, что были в лекции и в оригинале ДЗ, их отдельно не привожу. Вот лог сборки:


```````````````````````
Started by user admin
Running as SYSTEM
Building in workspace /var/lib/jenkins/workspace/hw-8-02
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/hw-8-02/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/Lebedun/8-02-jenkins # timeout=10
Fetching upstream changes from https://github.com/Lebedun/8-02-jenkins
 > git --version # timeout=10
 > git --version # 'git version 2.17.1'
 > git fetch --tags --progress -- https://github.com/Lebedun/8-02-jenkins +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 223dbc3f489784448004e020f2ef224f17a7b06d (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
Commit message: "Update README.md"
 > git rev-list --no-walk 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
[hw-8-02] $ /bin/sh -xe /tmp/jenkins8713379156983583576.sh
+ /usr/local/go/bin/go test .
ok  	github.com/netology-code/sdvps-materials	(cached)
[hw-8-02] $ /bin/sh -xe /tmp/jenkins3073854792165270058.sh
+ docker build . -t ubuntu-bionic:8082/hello-world:v3
#1 [internal] load .dockerignore
#1 transferring context: 2B done
#1 DONE 0.1s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 350B done
#2 DONE 0.2s

#3 [internal] load metadata for docker.io/library/golang:1.16
#3 ...

#4 [internal] load metadata for docker.io/library/alpine:latest
#4 DONE 0.3s

#3 [internal] load metadata for docker.io/library/golang:1.16
#3 DONE 0.6s

#5 [builder 1/4] FROM docker.io/library/golang:1.16@sha256:5f6a4662de3efc6d6bb812d02e9de3d8698eea16b8eb7281f03e6f3e8383018e
#5 DONE 0.0s

#6 [stage-1 1/3] FROM docker.io/library/alpine:latest@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11
#6 DONE 0.0s

#7 [internal] load build context
#7 transferring context: 13.06kB done
#7 DONE 0.1s

#8 [builder 3/4] COPY . ./
#8 CACHED

#9 [stage-1 2/3] RUN apk -U add ca-certificates
#9 CACHED

#10 [builder 2/4] WORKDIR /go/src/github.com/netology-code/sdvps-materials
#10 CACHED

#11 [builder 4/4] RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app .
#11 CACHED

#12 [stage-1 3/3] COPY --from=builder /app /app
#12 CACHED

#13 exporting to image
#13 exporting layers done
#13 writing image sha256:dc2a84e85a7d81ff9f3d7ae6edbc7ab77245eab2fcf96718071f30f6f3c913d8 0.0s done
#13 naming to ubuntu-bionic:8082/hello-world:v3 0.0s done
#13 DONE 0.0s
Finished: SUCCESS
```````````````````````


**Задание 2 : pipeline**

Скрипт (пришлось поковыряться с branch, по умолчанию jenkins пытается собрать ветку master, а не main).

```````````````````````
pipeline {
 agent any
 stages {
  stage('Git') {
   steps {git branch: 'main', url: 'https://github.com/Lebedun/8-02-jenkins.git'}
  }
  stage('Test') {
   steps {
    sh '/usr/local/go/bin/go test .'
   }
  }
  stage('Build') {
   steps {
    sh 'docker build . '
   }
  }
 }
}
```````````````````````

Лог выполнения:

```````````````````````
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/hw-8-02-2
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/hw-8-02-2/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/Lebedun/8-02-jenkins.git # timeout=10
Fetching upstream changes from https://github.com/Lebedun/8-02-jenkins.git
 > git --version # timeout=10
 > git --version # 'git version 2.17.1'
 > git fetch --tags --progress -- https://github.com/Lebedun/8-02-jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 223dbc3f489784448004e020f2ef224f17a7b06d (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
Commit message: "Update README.md"
 > git rev-list --no-walk 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] sh
+ /usr/local/go/bin/go test .
ok  	github.com/netology-code/sdvps-materials	0.001s
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] sh
+ docker build .
#1 [internal] load .dockerignore
#1 transferring context: 2B done
#1 DONE 0.1s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 350B done
#2 DONE 0.2s

#3 [internal] load metadata for docker.io/library/golang:1.16
#3 ...

#4 [internal] load metadata for docker.io/library/alpine:latest
#4 DONE 1.1s

#3 [internal] load metadata for docker.io/library/golang:1.16
#3 DONE 1.1s

#5 [builder 1/4] FROM docker.io/library/golang:1.16@sha256:5f6a4662de3efc6d6bb812d02e9de3d8698eea16b8eb7281f03e6f3e8383018e
#5 DONE 0.0s

#6 [stage-1 1/3] FROM docker.io/library/alpine:latest@sha256:02bb6f428431fbc2809c5d1b41eab5a68350194fb508869a33cb1af4444c9b11
#6 DONE 0.0s

#7 [internal] load build context
#7 transferring context: 101.36kB 0.0s done
#7 DONE 0.1s

#8 [builder 2/4] WORKDIR /go/src/github.com/netology-code/sdvps-materials
#8 CACHED

#9 [builder 3/4] COPY . ./
#9 DONE 0.5s

#10 [builder 4/4] RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix nocgo -o /app .
#10 DONE 7.4s

#11 [stage-1 2/3] RUN apk -U add ca-certificates
#11 CACHED

#12 [stage-1 3/3] COPY --from=builder /app /app
#12 CACHED

#13 exporting to image
#13 exporting layers done
#13 writing image sha256:dc2a84e85a7d81ff9f3d7ae6edbc7ab77245eab2fcf96718071f30f6f3c913d8 done
#13 DONE 0.0s
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```````````````````````

**Задание 3 : загрузка бинарника в репозиторий Nexus**

После предыдущего пункта и осознания того, что любую команду можно сначала потестить локально, это было уже несложно =).

Код:

```````````````````````
pipeline {
 agent any
 stages {
  stage('Git') {
   steps {git branch: 'main', url: 'https://github.com/Lebedun/8-02-jenkins.git'}
  }
  stage('Test') {
   steps {
    sh '/usr/local/go/bin/go test .'
   }
  }
  stage('Build') {
   steps {
    sh '/usr/local/go/bin/go build .'
    sh 'curl -u admin:woo8PreR+t http://51.250.91.224:8081/repository/8-02_raw/ --upload-file ./sdvps-materials  -v'
   }
  }
 }
}
```````````````````````

Лог:

```````````````````````
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/hw-8-02-2
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Git)
[Pipeline] git
The recommended git tool is: NONE
No credentials specified
 > git rev-parse --resolve-git-dir /var/lib/jenkins/workspace/hw-8-02-2/.git # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/Lebedun/8-02-jenkins.git # timeout=10
Fetching upstream changes from https://github.com/Lebedun/8-02-jenkins.git
 > git --version # timeout=10
 > git --version # 'git version 2.17.1'
 > git fetch --tags --progress -- https://github.com/Lebedun/8-02-jenkins.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 223dbc3f489784448004e020f2ef224f17a7b06d (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
 > git branch -a -v --no-abbrev # timeout=10
 > git branch -D main # timeout=10
 > git checkout -b main 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
Commit message: "Update README.md"
 > git rev-list --no-walk 223dbc3f489784448004e020f2ef224f17a7b06d # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] sh
+ /usr/local/go/bin/go test .
ok  	github.com/netology-code/sdvps-materials	(cached)
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] sh
+ /usr/local/go/bin/go build .
[Pipeline] sh
+ curl -u admin:woo8PreR+t http://51.250.91.224:8081/repository/8-02_raw/ --upload-file ./sdvps-materials -v
*   Trying 51.250.91.224...
* TCP_NODELAY set
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to 51.250.91.224 (51.250.91.224) port 8081 (#0)
* Server auth using Basic with user 'admin'
> PUT /repository/8-02_raw/sdvps-materials HTTP/1.1
> Host: 51.250.91.224:8081
> Authorization: Basic YWRtaW46d29vOFByZVIrdA==
> User-Agent: curl/7.58.0
> Accept: */*
> Content-Length: 1958036
> Expect: 100-continue
> 
< HTTP/1.1 100 Continue
} [16384 bytes data]
* We are completely uploaded and fine
< HTTP/1.1 201 Created
< Date: Sun, 14 May 2023 20:51:38 GMT
< Server: Nexus/3.53.1-02 (OSS)
< X-Content-Type-Options: nosniff
< Content-Security-Policy: sandbox allow-forms allow-modals allow-popups allow-presentation allow-scripts allow-top-navigation
< X-XSS-Protection: 1; mode=block
< Content-Length: 0
< 

100 1912k    0     0  100 1912k      0  35.2M --:--:-- --:--:-- --:--:-- 35.2M
* Connection #0 to host 51.250.91.224 left intact
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```````````````````````

