# Capi Example
Пример cluster-api инсталляции кластера k8s в окружении Selectel 

## Запуск management кластера
Для запуска примера кластера требуется исоплнить 
```bash
make bootstrap type=capi
```
Команда создаст kind кластер kind-capi с установленным flux и cluster-api-operator

В качестве примеров созданы манифесты для 2 типов кластеров - docker и openstack, распологающиеся в соответствующих директориях:
```
clusters/capi/docker-tenant
clusters/capi/os-tenant
```

## Авторизация openstack
Для авторизации cluster api и openstack требуется сформировать clouds.yaml из rc.sh ([инструкция для скачивания rc.sh](https://docs.selectel.ru/cloud-servers/tools/openstack/#download-rc-file-for-authorization-in-os))
Пример clouds.yaml
```yaml
clouds:
  openstack:
    auth:
      password: '1234'
      auth_url: https://cloud.api.selcloud.ru/identity/v3 # OS_AUTH_URL из rc.sh
      username: test-user # OS_USERNAME из rc.sh
      project_id: 1234qwerty1234 # OS_PROJECT_ID из rc.sh
      user_domain_name: '1234' # OS_USER_DOMAIN_NAME из rc.sh
      project_domain_name: '1234' # OS_PROJECT_DOMAIN_NAME из rc.sh
    compute_api_version: 2.72
    identity_api_version: 3
    image_api_version: 2
    volume_api_version: 3
    region_name: ru-3 # OS_REGION_NAME из rc.sh
```

Из файла clouds.yaml требуется создать секрет в management кластере cloud-config командой:

```bash
kubectl create secret generic cloud-config --type=addons.cluster.x-k8s.io/resource-set --from-file clouds.yaml -n os-tenant
```

## Запуск managed кластера
Чтобы запустить management кластер, требуется исполнить команду
```bash
kubectl create namespace docker-tenant
kubectl apply -k clusters/capi/docker-tenant
# Или
kubectl create namespace os-tenant
kubectl apply -k clusters/capi/os-tenant
```
Для os-tenant все дополнительные описания с пояснениями содержатся в комментариях к манифестам

## Временные фиксы
Из-за бага в k-orc - https://github.com/k-orc/openstack-resource-controller/issues/527#issuecomment-3354871148 было сделано ручное исравление customresourcedefinition в файле packages/orc/orc.yaml (строка 2008)

## Используемые инструменты:
| Name                     | Github link                                            |
| :------------------------| :------------------------------------------------------|
| kind                     | https://github.com/kubernetes-sigs/kind/               |
| flux                     | https://github.com/fluxcd/flux2                        |
| k-orc                    | https://github.com/k-orc/openstack-resource-controller |
| cloud-provider-openstack | https://github.com/kubernetes/cloud-provider-openstack |
| cluster-api              | https://github.com/kubernetes-sigs/cluster-api         |
