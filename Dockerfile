FROM alpine:3.13

LABEL maintainer="Yann Courtaux <ycourtaux@gmail.com>"

ENV VERSION 5.0.4
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-english.tar.xz
ENV MEMORY=512M
ENV UPLOAD=2048M

WORKDIR /srv

RUN apk upgrade --no-cache \
 && apk add --no-cache ca-certificates \
    php7 php7-opcache php7-session php7-iconv php7-mbstring php7-json php7-mysqli php7-zip \
    dumb-init \
 && wget $URL -O pma.tar.xz \
 && tar -xf pma.tar.xz -C /srv --strip-components=1 \
 && apk del ca-certificates \
 && rm pma.tar.xz \
 && sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /srv/libraries/vendor_config.php \
 && rm -rf /srv/setup/ /srv/examples/ /srv/test/ /srv/po/ /srv/composer.* /srv/yarn.lock /srv/RELEASE-DATE-$VERSION \
 && rm -rf /srv/doc/ /srv/themes/metro/ /srv/themes/original/ \
 && rm -rf /var/cache/apk/*

COPY *.inc.php /etc/phpmyadmin/

EXPOSE 8080

ENTRYPOINT ["dumb-init", "--"]

CMD /usr/bin/php \
    -d memory_limit=$MEMORY \
    -d upload_max_filesize=$UPLOAD \
    -d post_max_size=$UPLOAD \
    -S 0.0.0.0:8080
