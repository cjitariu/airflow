## AirFlow Deployment on OpenShift

## What's inside:

* CentOS/python36 based deployments AirFlow
* CentOS based Postgres deployment
* Images are optimized to run on OpenShift (correct uid and permissions for OpenShift user)
* Default usernames and passwords are used for Postgres connection

## How to Run

In the root of this repository:

```
./run.sh -p=$project
```
You can use own image in Airflow deployment:

```
./run.sh -p=$project -i=your/airflow-image
```

The script can also verify the deployment is healthy:

```
./run.sh -p=$project --wait
```

Print help:

```
./run.sh --help
```

## How to Configure git sync repo

git-sync container of airflow-web deployment has the following env:

```
- name: GIT_SYNC_REPO
  value: https://github.com/apache/airflow
- name: GIT_SYNC_BRANCH
  value: master
- name: GIT_SYNC_ROOT
  value: /git
- name: GIT_SYNC_DEST
  value: repo
- name: GIT_SYNC_WAIT
  value: "60"
- name: GIT_SYNC_USERNAME
  valueFrom:
    secretKeyRef:
      key: GIT_SYNC_USERNAME
      name: git
- name: GIT_SYNC_PASSWORD
  valueFrom:
    secretKeyRef:
      key: GIT_SYNC_PASSWORD
      name: git
```
Replace repo and branch and edit git secret to provision username and password for private repos.


## Images

There are 3 images used in deployments:

* centos/postgresql-94-centos7
* k8s.gcr.io/git-sync:v3.0.1
* serverbee/airflow

Dockerfiles for the latter are located in dockerfiles directory in this repository. There's also a script that builds this image `dockerfiles/airflow/build-docker.sh`.
Running this script without args will produce an image `airflow:latest`. You may pass arguments though:

```
./build-docker.sh myregistry/myorg/myimage mytag
```

This will produce an image `myregistry/myorg/myimage:mytag` which you can pass to `./run.sh` as `-i=myregistry/myorg/myimage:mytag`

## Logs

### Postgres

```
oc logs deployment/postgres
```

### Scheduler

There are two containers in scheduler pod:

```
oc logs deployment/airflow-scheduler -c git-sync
oc logs deployment/airflow-scheduler -c scheduler

```
### Web

There's an init container in web pod:

```
oc logs deployment/airflow-web -c init-airflow
```

And two containers in the pod:

```
oc logs deployment/airflow-web -c git-sync
oc logs deployment/airflow-web -c webserver
```
