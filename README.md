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
