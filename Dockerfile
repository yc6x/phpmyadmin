FROM alpine:3.13 as phpsrv

LABEL maintainer="Yann Courtaux <ycourtaux@gmail.com>"

ENV MEMORY=512M
ENV UPLOAD=2048M

WORKDIR /srv

RUN apk upgrade --no-cache && apk add --no-cache php7 php7-opcache php7-session \
    php7-mysqli php7-xml php7-iconv php7-mbstring php7-json php7-zip dumb-init

EXPOSE 8080

ENTRYPOINT ["dumb-init", "--"]

CMD /usr/bin/php \
    -d memory_limit=$MEMORY \
    -d upload_max_filesize=$UPLOAD \
    -d post_max_size=$UPLOAD \
    -S 0.0.0.0:8080

FROM phpsrv

COPY config/*.inc.php /etc/phpmyadmin/
COPY build/pma/ .
