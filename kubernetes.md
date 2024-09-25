

# KUBERNETES

ИНСТРУКЦИИ KUBECTL
Основные команды

Общая информация о кластере:
kubectl cluster-info

Информация о компонентах кластера:
kubectl get componentstatuses

Список всех узлов (нод):
kubectl get nodes

Подробная информация о ноде:
kubectl describe node <node_name>

Работа с Namespaces

Список всех namespaces:
kubectl get namespaces

Создание namespace:
kubectl create namespace <namespace_name>

Удаление namespace:
kubectl delete namespace <namespace_name>

Работа с Pods

Список всех подов:
kubectl get pods

Список подов в указанном namespace:
kubectl get pods -n <namespace>

Подробная информация о поде:
kubectl describe pod <pod_name>

Логи пода:
kubectl logs <pod_name>

Запуск шелла в контейнере пода:
kubectl exec -it <pod_name> -- /bin/bash

Работа с Deployments

Список всех deployments:
kubectl get deployments

Создание deployment из YAML файла:
kubectl apply -f <file.yaml>

Обновление deployment:
kubectl set image deployment/<deployment_name> <container_name>=<new_image>

Откат к предыдущей версии deployment:
kubectl rollout undo deployment/<deployment_name>

Работа с Services

Список всех сервисов:
kubectl get services

Подробная информация о сервисе:
kubectl describe service <service_name>

Работа с ConfigMaps и Secrets

Список всех ConfigMaps:
kubectl get configmaps

Создание ConfigMap из файла:
kubectl create configmap <configmap_name> --from-file=<file_path>

Список всех Secrets:
kubectl get secrets

Создание Secret из файла:
kubectl create secret generic <secret_name> --from-file=<file_path>

Работа с RBAC (Role-Based Access Control)

Список всех ролей:
kubectl get roles

Список всех rolebindings:
kubectl get rolebindings

Создание роли из YAML файла:
kubectl apply -f <role.yaml>

Создание привязки роли (rolebinding) из YAML файла:
kubectl apply -f <rolebinding.yaml>

Полезные опции

Переключение namespace:
kubectl config set-context --current --namespace=<namespace>

Фильтрация вывода по меткам (labels):
kubectl get pods -l <label_selector>

Сортировка вывода:
kubectl get pods --sort-by=.metadata.name

Вывод в формате YAML/JSON:
kubectl get pods -o yaml
kubectl get pods -o json



PODS

ИНСТРУКЦИИ. Создание и управление Pods

Создание пода из YAML файла:
kubectl apply -f <file.yaml>

Удаление пода:
kubectl delete pod <pod_name>

Перезапуск пода:
kubectl delete pod <pod_name> --grace-period=0 --force

Список подов:
kubectl get pods

Список подов в указанном namespace:
kubectl get pods -n <namespace>

Подробная информация о поде:
kubectl describe pod <pod_name>

Логи пода:
kubectl logs <pod_name>

Логи конкретного контейнера в поде:
kubectl logs <pod_name> -c <container_name>

Потоковые логи пода:
kubectl logs -f <pod_name>

Потоковые логи конкретного контейнера в поде:
kubectl logs -f <pod_name> -c <container_name>

Запуск шелла в контейнере пода:
kubectl exec -it <pod_name> -- /bin/bash

Выполнение команды в контейнере пода:
kubectl exec <pod_name> -- <command>

Проброс порта из пода на локальную машину:
kubectl port-forward <pod_name> <local_port>:<remote_port>

Копирование файлов из пода на локальную машину:
kubectl cp <pod_name>:<path/to/file> <local_path>

Копирование файлов с локальной машины в под:
kubectl cp <local_path> <pod_name>:<path/to/file>

Фильтрация подов по меткам (labels):
kubectl get pods -l <label_selector>

Сортировка вывода подов:
kubectl get pods --sort-by=.metadata.name

Вывод списка подов в формате YAML:
kubectl get pods -o yaml

Вывод списка подов в формате JSON:
kubectl get pods -o json
