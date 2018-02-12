[![Docker Pulls](https://img.shields.io/docker/pulls/machy8/docker-nginx-proxy-server.svg)](https://hub.docker.com/r/machy8/docker-nginx-proxy-server/)
[![Docker Build Status](https://img.shields.io/docker/build/machy8/docker-nginx-proxy-server.svg)]()

# Docker nginx proxy server

This repo is a simple Nginx proxy server you can run in Docker.

Pull image
````
docker pull machy8/docker-nginx-proxy-server
````

Required network
````
docker network create proxy-server
````

## Example 
- Open your console and run `docker network create proxy-server`

- Create a docker-compose.yml file for the proxy-server
````yaml
version: '3'
services:
  server:
    container_name: proxy-server
    image: machy8/docker-nginx-proxy-server
    volumes:
        - ./sites.d/test-web:/etc/nginx/sites.d/test-web
        - ./log:/var/log/nginx
    networks:
        - proxy-server
    ports:
        - "80:80"
        - "443:443"

networks:
    proxy-server:
        external:
            name: proxy-server
````

- Create a directory /sites.d/test-web (example with certificates bellow)
````
- docker-compose.yml
- sites.d
    - test-web
        - certificates
            - letsencrypt.crt
            - letsencrypt.key
        - test-web.conf
````

- Create a configuration file (for example test.com.conf) in the hosts directory
````nginx
server {
    listen 80;
    server_name localdev.test.com test.com;
    
    proxy_redirect   off;
    proxy_set_header Host $host;
    
    location / {
        proxy_pass  http://test-web/; # Blog web is the name of the container
    }
}
````

- Connect containers you want to connect to proxy server to the proxy-server network
````yaml
version: "3"
services:
    web:
        container_name: test-web
        image: nginx:alpine
        networks:
            - proxy-server

networks:
    proxy-server:   # This is the name for network used in THIS configuration file
        external:   # This says, that the network is external (not within this docker-compose.yml)
            name: proxy-server  # This s the name of the external network
````

- (optional) Edit your hosts file
````
127.0.0.1 localhost
127.0.0.1 localdev.test.com test.com
````
- Build and start the container with your test web
- Build and start the container with proxy-server
- Open browser and connect to http://localdev.test.com

## Certbot (Lets Encrypt)
- Proxy server already contains [certbot](https://certbot.eff.org/)
- Nginx is configured to redirect all .well-known paths to the `/var/www/html` directory in order to allow Let's Encrypt to check and generate the certificates
