FROM registry.fit2cloud.com/public/python:v3
MAINTAINER Jumpserver Team <ibuler@qq.com>

WORKDIR /opt/jumpserver
RUN useradd jumpserver

COPY ./requirements /tmp/requirements
RUN yum -y install epel-release openldap-clients telnet && cd /tmp/requirements && \
    yum -y install $(cat rpm_requirements.txt)

RUN cd /tmp/requirements &&  pip install -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt || pip install -r requirements.txt

COPY . /opt/jumpserver
RUN echo > config.yml
VOLUME /opt/jumpserver/data
VOLUME /opt/jumpserver/logs

ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]


RUN yum -y install epel-release \
    && yum -y install nginx

RUN curl -L https://github.com/jumpserver/luna/releases/download/1.4.8/luna.tar.gz > luna.tar.gz   \
    && tar xf luna.tar.gz -C /opt  \
    && rm -f luna.tar.gz

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
