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

RUN a2enmod rewrite

RUN find /var/lib/apt/lists/ -type f -delete
RUN find /var/cache/apt/archives/ -type f -delete

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 80

CMD ["apache2","-DFOREGROUND"]
