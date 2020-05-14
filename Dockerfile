FROM ubuntu:12.04
LABEL LABEL maintainer="305674+jeremyj@users.noreply.github.com"

RUN sed -i 's/universe$/universe multiverse/' /etc/apt/sources.list
RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get -yq install \
	wget \
	php-auth \
	php-mail-mime \
	php-mail-mimedecode \
	php-mdb2 \
	php-mdb2-driver-mysql \
	php-net-smtp \
	php-net-socket \
	php-pear \
	php5-curl \
	php5-fpm \
	php5-gd \
	php5-imap \
	php5-intl \
	php5-ldap \
	php5-mcrypt \
	php5-memcache \
	php5-mysql \
	php5-pspell \
	libapache2-mod-fastcgi

COPY pear-package.list pear-package.list
RUN cat pear-package.list | while read file; do wget $file ;done
RUN for i in `ls *.tgz`; do pear install $i && rm -f $i; done

#COPY DB_Pager-0.7.tgz DB_Pager-0.7.tgz
#COPY HTML_Common-1.2.5.tgz HTML_Common-1.2.5.tgz
#COPY Pager_Sliding-1.6.tgz Pager_Sliding-1.6.tgz
#COPY XML_Parser-1.3.4.tgz XML_Parser-1.3.4.tgz
#COPY XML_Serializer-0.20.2.tgz XML_Serializer-0.20.2.tgz
#COPY XML_Util-1.2.1.tgz XML_Util-1.2.1.tgz
#
#RUN pear install DB_Pager-0.7.tgz
#RUN pear install HTML_Common-1.2.5.tgz
#RUN pear install Pager_Sliding-1.6.tgz
#RUN pear install XML_Util-1.2.1.tgz
#RUN pear install XML_Parser-1.3.4.tgz
#RUN pear install XML_Serializer-0.20.2.tgz
#
#RUN rm DB_Pager-0.7.tgz HTML_Common-1.2.5.tgz Pager_Sliding-1.6.tgz XML_Util-1.2.1.tgz XML_Parser-1.3.4.tgz XML_Serializer-0.20.2.tgz 

RUN a2enmod rewrite

RUN find /var/lib/apt/lists/ -type f -delete
RUN find /var/cache/apt/archives/ -type f -delete

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 80

CMD ["apache2","-DFOREGROUND"]
