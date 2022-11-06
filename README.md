# Домашняя работа "Terraform"   
  
## Содержание репозитория:
- main.tf - манифест Terraform, разворачивающий виртуальную машину в yandex cloud  
- variables.tf - объявление используемых переменных  
- ansible.cfg - общие настройки ansible  
- nginx.yml - ansible playbook, разворачивающий nginx на созданной виртуальной машине 
  
Перед запуском необходимо, чтобы были выполнены слудющие условия:  
  
- рабочий yandex cloud с возможностью создавать в нём виртуальные машины и сети, 
- известны  [Yandex Cloud ID](https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id), [Folder ID](https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id), а так же получен [iam-токен](https://cloud.yandex.ru/docs/iam/concepts/authorization/iam-token)   
- локально установленный [terraform](https://hashicorp-releases.yandexcloud.net/terraform/)
- локально установленный [ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)

Для разворачивания стенда необходимо:
1. Инициализировать рабочую среду Terraform:

```
$ terraform init
```
В результате будет установлен провайдер для подключения к облаку Яндекс.

2. Запустить разворачивание стенда:
```
$ terraform apply
```
В процессе разворачивания будут запрошены cloud_id, folder_id и iam-token. При желании эти значения можно задать соответсвующим переменным в variables.tf.
В результате разворачивания получим виртуальную машину в облаке Яндекс со следующими параметрами:
- 2 CPU;
- 2 GB RAM;
- 5 GB диск;
- операционная система ???;
- пользователь ???, авторизация по ключу (~/.ssh/id-rsa);
- сетевой интерфейс, подключенный к виртуальной сети;
- внешний ip адрес;
- развёрнутый и запущенный Nginx (устанавливается с помощью ansible-playbook).
