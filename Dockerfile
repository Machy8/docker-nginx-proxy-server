FROM nginx:alpine

RUN apk add --no-cache openssl certbot

RUN rm -rf /etc/nginx/conf.d/*

RUN mkdir -p /var/www/html

RUN mkdir -p /etc/nginx/certs

COPY conf.d /etc/nginx/conf.d

COPY ssl/dhparam2048.pem /etc/nginx/certs

COPY nginx.conf /etc/nginx

EXPOSE 80 443
