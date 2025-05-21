#  Курсовая работа на профессии "DevOps-инженер с нуля" - `Горелов Николай`


Содержание
==========
* [Задача](#Задача)
* [Инфраструктура](#Инфраструктура)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
    * [Резервное копирование](#Резервное-копирование)
---

## Стандартные приготовления для работы с Yandex Cloud:
* Зарегистрироваться в Yandex Cloud
* Создайте платежный аккаунт (привязав банковскую карту)
* Активация промокода от Netology
* Создать сервисный аккаунт для работы с Yandex Cloud через terraform. Роль editor достаточно для всех манипуляций

На этапе создания сервисного аккаунта первый и последний раз будет доступен authorized_key.json. Его надо сохранить к себе на ПК. В моём случае это папка с курсовой работой.

Все файлы содержащие чувствительные данные будут добавлены в файл ".gitignore" для недоступности к добавлению на github.

Все дальнейшие действия будут через terraform и ansible.



terraform init
terraform apply
yes


nimda@vm1:~/Netology/netology-coursework$ ssh-agent -a nimda@ip_bastion
SSH_AUTH_SOCK=nimda@ip_bastion; export SSH_AUTH_SOCK;
SSH_AGENT_PID=3414661; export SSH_AGENT_PID;
echo Agent pid 3414661;
nimda@vm1:~/Netology/netology-coursework$ ssh-add ~/.ssh/yc_coursework
Enter passphrase for /home/nimda/.ssh/yc_coursework: 
Identity added: /home/nimda/.ssh/yc_coursework (my-yc-coursework)
nimda@vm1:~/Netology/netology-coursework$


nimda@vm1:~/Netology/netology-coursework$ ansible-playbook ansible/site.yml -i ansible/inventory.ini

ansible/inventory.ini 



## Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/).

Для выполнения условий задачи По условиям задачи нам понадобиться как минимум 7 виртуальных машин:  
![](img/YC-virtualmachine.JPG)


## Инфраструктура
Для развёртки инфраструктуры используйте Terraform и Ansible. 

Параметры виртуальной машины (ВМ) подбирайте по потребностям сервисов, которые будут на ней работать. 

![](img/terraform-apply%20result.JPG)
![](img/ansible%20cmd.JPG)
![](img/ansible-result.JPG)

### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.

![](img/YC-targetgroup.JPG)

Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

![](img/YC-backendgroup.JPG)

Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.

![](img/YC-http-router.JPG)

Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

![](img/YC-L7-balancer.JPG)


Протестируйте сайт
`curl -v <публичный IP балансера>:80` 

![](img/curl-loadbalancer.JPG)

### Мониторинг
Создайте ВМ, разверните на ней Prometheus. На каждую ВМ из веб-серверов установите Node Exporter и [Nginx Log Exporter](https://github.com/martin-helmich/prometheus-nginxlog-exporter). Настройте Prometheus на сбор метрик с этих exporter.

Создайте ВМ, установите туда Grafana. Настройте её на взаимодействие с ранее развернутым Prometheus. Настройте дешборды с отображением метрик, минимальный набор — Utilization, Saturation, Errors для CPU, RAM, диски, сеть, http_response_count_total, http_response_size_bytes. Добавьте необходимые [tresholds](https://grafana.com/docs/grafana/latest/panels/thresholds/) на соответствующие графики.

![](img/grafana-dashboards.JPG)
![](img/grafana-nginx-exporter-dashboard.JPG)
![](img/grafana-node-exporter-dashboard.JPG)
![](img/grafana-node-exporter-win2-dashboard.JPG)

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

![](img/ELK-Kibana.JPG)

### Сеть
Разверните один VPC. Сервера web, Prometheus, Elasticsearch поместите в приватные подсети. Сервера Grafana, Kibana, application load balancer определите в публичную подсеть.

Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh. Настройте все security groups на разрешение входящего ssh из этой security group. Эта вм будет реализовывать концепцию bastion host. Потом можно будет подключаться по ssh ко всем хостам через этот хост.

![](img/YC-network.JPG)
![](img/YC-security-gp.JPG)
![](img/YC-security-gp-ssh.JPG)

### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.
![](img/YC-snapshot.JPG)