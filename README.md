This repo is a simple proxy server you can run in Docker.

## Example
I would recommend to use docker-compose.yml in your project for the next steps .

- Clone this repo whether you want
- Edit your hosts file
````
127.0.0.1 localhost
127.0.0.1 localdev.test.com test.com
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
````
server {
    listen 80;
    server_name localdev.test.com test.com
    
    proxy_redirect   off;
    proxy_set_header Host $host;
    
    location / {
        proxy_pass  http://test-web/; # Blog web is the name of the container
    }
}
````

- Build and start the container with your test web
- Build and start the container with proxy-server
- Open browser and connect to http://localdev.test.com
