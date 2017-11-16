This repo is a simple Nginx proxy server you can run in Docker.

## Example 
I would recommend to use docker-compose.yml in your project for the next steps .

- Clone or pull this repo
````yaml
version: "3"
services:
    web:
        container_name: test-proxy
        image: machy8/docker-nginx-proxy-server
        volumes:
            - /sites.d/test-web:/etc/nginx/sites.d/test-web
````
- Make directory /sites.d/test-web (example with certificates bellow)
````
- docker-compose.yml
- sites.d
    - test-web
        - certificates
            - letsencrypt.crt
            - letsencrypt.key
        - test-web.conf
````
- Open your console and run `docker network create proxy-server`
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

- Add config (for example test.com.conf) file into the hosts directory
````conf
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
- (optional) Edit your hosts file
````
127.0.0.1 localhost
127.0.0.1 localdev.test.com test.com
````
- Build and start the container with your test web
- Build and start the container with proxy-server
- Open browser and connect to http://localdev.test.com
