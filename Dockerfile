FROM nginx:alpine

RUN rm -rf /etc/nginx/conf.d/*
COPY hosts/ /etc/nginx/conf.d/
