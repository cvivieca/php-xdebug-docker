FROM php:7.4.6-fpm-buster

# If you are running of same machine you can use Docker Networking features. Instead, if you are running using WSL2 for example, you have to set your WSL2 IP Address
# https://docs.docker.com/docker-for-mac/networking/
ENV XDEBUG_HOST=host.docker.internal
ENV XDEBUG_PORT=9000
ENV XDEBUG_LOGS_FILE=/tmp/xdebug.log

# Install and Enable XDebug. If you are using a an old version of XDebug you should map new XDebug keys with old ones. 
# https://xdebug.org/docs/upgrade_guide
RUN pecl install xdebug  \
    && docker-php-ext-enable xdebug \
    && echo -e "xdebug.mode=debug \n\
                xdebug.start_with_request=trigger \n\
                xdebug.client_host=${XDEBUG_HOST} \n\
                xdebug.client_port=${XDEBUG_PORT} \n\
                xdebug.log=${XDEBUG_LOGS_FILE}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install XDebug helper for debugging console commands
# Source: https://github.com/dbalabka/phpdebug-cli
RUN apt-get install curl

RUN curl https://raw.githubusercontent.com/torinaki/phpdebug-cli/master/phpdebug.sh > ~/.phpdebug

RUN echo -e "# Get the aliases and functions    \n\
            if [ -f ~/.phpdebug ]; then         \n\
                . ~/.phpdebug                   \n\
            fi "

CMD /bin/bash source /root/.bashrc && phpdebug
