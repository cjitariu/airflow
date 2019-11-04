## AirFlow Deployment on OpenShift

## What's inside:

* CentOS/python36 based deployments AirFlow
* CentOS based Postgres deployment
* Images are optimized to run on OpenShift (correct uid and permissions for OpenShift user)
* Default usernames and passwords are used for Postgres connection

## How to Run

In the root of this repository:

```
./run.sh
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

## UID for DAG Pods

Airflow configmap will instruct scheduler to run pods as user `1000160000`:

```
git_sync_run_as_user = 1000160000
```

Change it to the range that makes sense for your OpenShift namespace.

## Images

There are 3 images used in deployments:

* centos/postgresql-94-centos7
* k8s.gcr.io/git-sync:v3.0.1
* serverbee/airflow

Dockerfiles for the latter are located in dockerfiles directory in this repository.
