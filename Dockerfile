FROM ubuntu:12.04
MAINTAINER Sqeven admin@sqeven.com
#ADD ./sources.list /etc/apt/sources.list

RUN apt-get update
#RUN apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    make \
    gcc \
    g++ \
    automake \
    libtool \
    mysql-client \
    libmysqlclient15-dev \
    libxml2-dev \
    libexpat1-dev \
    cron

RUN mkdir -p /usr/local/src/coreseek
ADD ./coreseek /usr/local/src/coreseek
RUN chmod 755 -R /usr/local/src/coreseek

WORKDIR /usr/local/src/coreseek/mmseg-3.2.14
RUN ./bootstrap
RUN ./configure --prefix=/usr/local/mmseg3
RUN make && make install

WORKDIR /usr/local/src/coreseek/csft-4.1
RUN ./buildconf.sh
RUN ./configure --prefix=/usr/local/coreseek --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
RUN make && make install

RUN rm -Rf /usr/local/src/coreseek

ADD ./cron/sphinx /etc/cron.hourly/sphinx

VOLUME ['/usr/local/etc/sphinx', '/var/log/sphinx']

RUN ln -s /usr/local/etc/sphinx/sphinx.conf /usr/local/etc/csft.conf
RUN mkdir -p /var/sphinx/log/
RUN mkdir -p /var/sphinx/data/

WORKDIR /

EXPOSE 9312

ADD ./seven.sh /
RUN chmod +x /seven.sh

#ENTRYPOINT ["/seven.sh"]
