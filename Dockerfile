FROM nginx:alpine

RUN apk add --no-cache openssl certbot

RUN rm -rf /etc/nginx/conf.d/*

RUN mkdir -p /var/www/html

COPY conf.d /etc/nginx/conf.d

COPY nginx.conf /etc/nginx

EXPOSE 80 443
