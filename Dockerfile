FROM nginx:1.15

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> "/etc/apt/sources.list" && \
    apt-get update && apt-get install -y certbot -t stretch-backports

RUN rm -rf /etc/nginx/conf.d/*

RUN mkdir -p /var/www/html

RUN mkdir -p /etc/nginx/certs

COPY conf.d /etc/nginx/conf.d

COPY ssl/dhparam2048.pem /etc/nginx/certs

COPY nginx.conf /etc/nginx

EXPOSE 80 443
