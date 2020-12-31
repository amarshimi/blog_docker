FROM centos:7.4.1708

RUN yum -y update

RUN yum install epel-release yum-utils -y
RUN yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
RUN yum-config-manager --enable remi-php73

RUN yum install -y \
    gcc \
    gcc-c++ \
    httpd \
    nano \
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
    php-mbstring \
    git

RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

RUN sed -i -e 's/memory_limit = 128M/memory_limit = -1/g' /etc/php.ini

RUN sed -i -e 's/\/var\/www\/html/\/var\/www\/html\/web/g' /etc/httpd/conf/httpd.conf

EXPOSE 80 443

WORKDIR /var/www/html

COPY ./html/ ./

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

RUN php composer-setup.php --version=1.10.16
RUN php -r "unlink('composer-setup.php');"
RUN mv -v composer.phar /usr/bin/composer

#RUN composer install

RUN composer require drupal/console:~1.0 --prefer-dist --optimize-autoloader
RUN echo 'alias drupal="vendor/bin/drupal"' >> ~/.bashrc


RUN curl -fSL "https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar" -o drush.phar
RUN chmod +x drush.phar
RUN mv -v drush.phar /usr/bin/drush

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
