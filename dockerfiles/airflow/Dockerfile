# VERSION 1.10.1
# AUTHOR: Matthieu "Puckel_" Roisil
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t puckel/docker-airflow .
# SOURCE: https://github.com/puckel/docker-airflow

# Disclaimer: I take no credit for this Dockerfile. It is a copy of the original
# with a minor change to have git available. Please start from the original Dockerfile
# for your own setup.

#FROM python:3.6-slim
FROM centos/python-36-centos7:latest
LABEL maintainer="Puckel_"

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
ENV LD_LIBRARY_PATH=/opt/rh/rh-python36/root/usr/lib64
# Airflow
ARG AIRFLOW_VERSION=1.4.0
ARG AIRFLOW_HOME=/usr/local/airflow
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_GPL_UNIDECODE yes

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
USER root
RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libpq-dev \
    ' \
    && yum update -yqq \
    && yum upgrade -yqq \
    && yum install -yqq  \
        $buildDeps \
        freetds-bin \
        build-essential \
        default-libmysqlclient-dev \
        apt-utils \
        curl \
        rsync \
        netcat \
        locales \
	libpq5 \
        git \
    && pip install -U pip setuptools wheel \
    && pip install pytz \
    && pip install psycopg2-binary \
    && pip install psycopg2 \
    && pip install pyOpenSSL \
    && pip install ndg-httpsclient \
    && pip install pyasn1 \
    && pip install apache-airflow[crypto,celery,postgres,hive,jdbc,mysql,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}] \
    && pip install 'redis>=2.10.5,<3' \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi \
    && yum remove -y $buildDeps \
    && yum clean all
ENV HOME /opt/app-root/src
RUN mkdir -p /usr/local/airflow /git && for f in "/usr/local/airflow" "/etc/passwd" "/etc/group" "/git"; do\
          chgrp -R 0 ${f} && \
          chmod -R g+rwX ${f} && \
          chmod -R 777 /usr/local/airflow /git; \
        done && \
        # Generate passwd.template \
        cat /etc/passwd | \
        sed s#default:x.*#default:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/bash#g \
        > /opt/app-root/src/passwd.template && \
        # Generate group.template \
        cat /etc/group | \
        sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
        > /opt/app-root/src/group.template
RUN yum install nmap-ncat -y
COPY script/entrypoint.sh /entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/usr/local/airflow.cfg
USER default
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
