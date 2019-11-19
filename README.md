docker-machine create --driver google  --google-machine-image ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20190628  --google-machine-type n1-standard-1  --google-zone europe-west1-b  docker-host

## 12) Docker

выполнены обычные задания и задания со *

образ отличается от контейнера тем, что образ это статичное состояние контейнера из которого всегда можно развернуть такой же контейнер
образ в докере  - чет типа тэга в гите 

создал докер-машины в гугле и на сервере в локалке

потыкал демки

запушил образ на хаб

реализовал создание терраформом заданного количества инстансов с предустановленным докером через пакер и пустых

ансиблом на те где нет докера докер ставится и на всех пуллится образ и стартует контейнер с приложением 80 порт хостов замаплен на порты приложений

подключен тревис и оповещения в слак 

##13) 

выполнены основные задания и задания со * 

для запуска сдругими алиасами и конфигами достаточно выполнить 
```
docker kill $(docker ps -q)
docker run -d --network=reddit --network-alias=post_db2 --network-alias=comment_db2 -v reddit_db:/data/db mongo:latest
docker run -d --network=reddit --network-alias=post2 -e POST_DATABASE_HOST=post_db2 flamerior/post:1.0
docker run -d --network=reddit --network-alias=comment2 -e COMMENT_DATABASE_HOST=comment_db2 flamerior/comment:1.0
docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=post2 -e COMMENT_SERVICE_HOST=comment2 flamerior/ui:1.0
```
задавая при запуске алиасы и значения енв переменных

подшаманил докерфайлы на основе альпайн с чисткой того что используется при сборке и порядком инструкций для кэширования слоев
 в итоге
```
flamerior/ui                                            2.0                 157MB
flamerior/post                                          1.0                 109MB
flamerior/comment                                       1.0                 154MB
```
подключил volume для базы

заодно разобрался с форматированием вывода команд докера
```docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}} ' -f "reference=flamerior/*:*"```

##14)
поэксперементировал с сетями 
реализовал docker-compose и docker-compose.override 
проверил что доступно изменение кода без перезапуска
сменил префикс
приложение доступно на 80 м порту после docker-compose up -d


##15) 
терраформом создаются инстанс гитлаба, дев сервер и несколько раннеров 
ансиблом раскатывается докер и настраиваются ранеры (сначала необходимо задействовать инициализацию гитлаба, а уже потом ввести токен и ип для инициализации ранеров)
настроил пайплайн для запуска теста в докере на ранере и для деплоя на дев сервер
использовал переменные среды гитлаба для хранения логина пароля докер хаба и приватного ключа доступа к дев серверу


## 16)
- запустил prometheus и настроил докерфайл
- помучал метрики 
- написал композ и добавил в него сервисы и экспортеры
- подключил percona/mongodb-exporter

```
git clone https://github.com/percona/mongodb_exporter.git
cd mongodb_exporter/
make docker
docker tag mongodb-exporter:master flamerior/mongodb-exporter
docker push flamerior/mongodb-exporter
```

- подключил blackbox-exporter
- написал Makefile (хелп парсится из самого файла и используется форматирование с цветом)
- запушил образы
https://cloud.docker.com/u/flamerior/repository/list

## 17)
- поднял графану 
- поигрался с дашбордами
- настроил подхватывание источников и дашбордов на старте
- настроил alertmanager и поигрался с способами алертов (конфиги для почты выпилил)
- помучал экспериментальные метрики
```
/etc/docker/daemon.json

{
     "metrics-addr" : "127.0.0.1:9323",
     "experimental" : true
   }
```

- помучал advisor
- дополнил Makefile
- подключил telegraf
- помучал stackdriver


```
Install the Stackdriver Monitoring agent.

curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
sudo bash install-monitoring-agent.sh

Install the Stackdriver Logging agent.

curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
sudo bash install-logging-agent.sh --structured
```

- подключил trickster
- настроил простейший вариант autoheal для ui - пришлось добавить curl в контейнер чтобы работало


## 18)

- настроил efk
- решил проблему  max virtual memory для еластика через sudo sysctl -w vm.max_map_count=262144
- настроил кибану и парсинг json логов
- добавил grok шаблон для логов которые не парсились
- настроил Zipkin
- нашел ошибку в коде с помощью трейсинга - стояла задержка 3 секунды 


## 19)
- прошел The Hard Way
- использовал tmux (для открытия 3х консолей на контроллеры использовать команду)
```bash
tmux new-session gcloud compute ssh controller-0 \; split-window -v gcloud compute ssh controller-1 \; split-window -v gcloud compute ssh controller-2 \; select-layout even-vertical \; attach-session
```

- попробовал kubespray на 5 дроплетах DO c небольшим применением бубна и метода научного тыка
- завернул локальные шаги в баш, а удаленые в ансибл


для создания кластера
```
cd kubernetes/ansible/
./init_kuber.sh 
ansible-playbook deploy_controllers.yml 
./create_lb.sh 
ansible-playbook deploy_workers.yml 
./finish_install.sh 
./test.sh 
```

для деплоя нашего приложения
```
kubectl apply -f ../reddit
kubectl get all
```

для удаления кластера
```
./destroy.sh 
```


##20)
- поставил миникуб
- создал кластер в GKE
- создал кластер в GKE через терраформ
- настроил приложение в кубере
- настроил дашборд кубера

```
terraform apply
``` 
в папке терраформ

```
kubectl apply -f reddit/dev-namespace.yml 
kubectl apply -f reddit
kubectl apply -f dashboard
kubectl proxy
kubectl get nodes -o wide
kubectl -n dev get services

```


##21)
- помучал kube-dns
- настроил гугловый лоад балансер
- настроил ingress
- создал tls секрет
- запретил http
- *описал секрет в виде манифеста*
- настроил NetworkPolicy
- создал диск в gce
- примонтировал
- создал PersistentVolume
- настроил PersistentVolumeClaim
- создал StorageClass fast
- подключил его к монге

##22)

- развернул прометей
- настроил релабел
- cadvisor
- node-exporter
- метрики приложения
- разбил на job-ы post-endpoints, commentendpoints, ui-endpoints
- поднял графану через helm подсунув источник данных и дашборды в чарт
- настроил переменную в графане для namespace кубера в дашбордах метрик приложения
- запустил alertmanager для аписервера и хостов k8s
- установил prometheus-operator через чарт и прописал в нем манифест 
```

  additionalServiceMonitors:
    - name: post-component
      selector:
        matchLabels:
          component: post
      namespaceSelector:
        any: true
      endpoints:
        - targetPort: 5000
          interval: 30s
          path: /metrics
          scheme: http
```
- добавил лабел мощным нодам
- завернул в один чарт *efk* развертывание логирования (fluentd elastic kibana отдельные чарты тоже лежат в папке charts требуется namespace logging)
