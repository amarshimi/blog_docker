FROM centos:7.4.1708

RUN yum -y update

RUN yum install epel-release yum-utils -y
RUN yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
RUN yum-config-manager --enable remi-php81

RUN yum install -y \
    gcc \
    gcc-c++ \
    httpd \
    mod_ssl \
    mod_rewrite \
	zip \
	unzip \
    php \
    php-common \
    php-opcache \
    php-mcrypt \
    php-cli \
    php-gd \
    php-curl \
    php-mysql \
    php-dom \
    php-xml \
    php-zip \
    php-ldap \
    php-mbstring \
    php-pecl-memcache \
    php-redis \
    git \
    nano

RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf

RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

RUN sed -i -e 's/\/var\/www\/html/\/var\/www\/html\/web/g' /etc/httpd/conf/httpd.conf

RUN sed -i -e 's/memory_limit = 128M/memory_limit = -1/g' /etc/php.ini


RUN echo "AddOutputFilterByType DEFLATE text/plain" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE text/html" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE text/xml" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE text/css" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE application/xml" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE application/xhtml+xml" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE application/rss+xml" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE application/javascript" >> /etc/httpd/conf/httpd.conf
RUN echo "AddOutputFilterByType DEFLATE application/x-javascript" >> /etc/httpd/conf/httpd.conf

RUN mkdir /etc/httpd/sites-available
RUN mkdir /etc/httpd/sites-enabled

RUN export USER_NAME=root

EXPOSE 80 443

WORKDIR /var/www/html

COPY ./html/ ./

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv -v composer.phar /usr/bin/composer

RUN curl -OL "https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar" -o drush.phar
RUN chmod +x drush.phar
RUN mv -v drush.phar /usr/bin/drush

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
