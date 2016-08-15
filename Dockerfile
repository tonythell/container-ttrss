FROM ubuntu
MAINTAINER Tony Thell <tony969@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get install -y \
  nginx git supervisor vim php-fpm php-cli php-curl php-gd php-json \
  php-pgsql php-mbstring php-mcrypt php-xml && apt-get clean

# enable the mcrypt module
RUN phpenmod mcrypt

# create php directory so php-fpm can create a socket
RUN mkdir /var/run/php

# add ttrss as the only nginx site
ADD ttrss.nginx.conf /etc/nginx/sites-available/ttrss
RUN ln -s /etc/nginx/sites-available/ttrss /etc/nginx/sites-enabled/ttrss
RUN rm -rf /etc/nginx/sites-enabled/default /var/www/html

# install ttrss and patch configuration
RUN git clone https://github.com/dittos/ttrss-mirror.git /var/www
# add 3rd-party themes
COPY themes/* /var/www/themes/
WORKDIR /var/www
RUN cp config.php-dist config.php
RUN sed -i -e "/'SELF_URL_PATH'/s/ '.*'/ 'http:\/\/localhost\/'/" config.php
RUN chown www-data:www-data -R /var/www

# expose only nginx HTTP port
EXPOSE 80

# expose default database credentials via ENV in order to ease overwriting
ENV DB_NAME ttrss
ENV DB_USER ttrss
ENV DB_PASS ttrss

# always re-configure database with current ENV when RUNning container and
# then monitor all services
ADD configure-db.php /configure-db.php
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD php /configure-db.php && supervisord -c /etc/supervisor/conf.d/supervisord.conf
