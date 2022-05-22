![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/noctuary/phpmyadmin/latest?style=plastic)    ![Image size](https://img.shields.io/docker/image-size/noctuary/phpmyadmin/latest?style=plastic)    ![Docker Pulls](https://img.shields.io/docker/pulls/noctuary/phpmyadmin?style=plastic)

Docker Hub: [noctuary/phpmyadmin](https://hub.docker.com/r/noctuary/phpmyadmin)

## A tiny phpMyAdmin standalone image

The compressed image size is 12 MB.  
Once pulled, it will take 36 MB of disk space. 

It is 15 times smaller than the [Docker Official phpmyadmin images](https://hub.docker.com/_/phpmyadmin) (standalone: including Apache web server).  

### Why is it so small?

One language only: english.  
One theme only: pmahome.  
2 non mainstream features where disabled: PDF schema export, GIS visualization.  
Runs in Alpine Linux.  
No extra web server: use the PHP built in web server.  

## Usage
phpMyAdmin uses **db** as default MySQL/MariaDB server host name.   
Assuming a MySQL or MariaDB server is running in Docker, as a container named **db**:
```
docker run --rm --name phpmyadmin -d -p 8080:8080 noctuary/phpmyadmin
```
If your MySQL or MariaDB container name is not **db**, you have to alias it to **db** with the link option:
```
docker run --rm --name phpmyadmin -d --link mariadb:db -p 8080:8080 noctuary/phpmyadmin
```

## Environment variables

`noctuary/phpmyadmin` accepts the same environment variables as the `phpmyadmin/phpmyadmin` [Docker Official phpmyadmin images](https://hub.docker.com/_/phpmyadmin) :

- `PMA_ARBITRARY` - when set to 1, you will have to specify MySQL/MariaDB server address/host name on login page
- `PMA_HOST` - define address/host name of the MySQL server
- `PMA_VERBOSE` - define verbose name of the MySQL server
- `PMA_PORT` - define port of the MySQL server
- `PMA_HOSTS` - define comma separated list of address/host names of the MySQL servers
- `PMA_VERBOSES` - define comma separated list of verbose names of the MySQL servers
- `PMA_PORTS` - define comma separated list of ports of the MySQL servers
- `PMA_USER` and `PMA_PASSWORD` - define username to use for config authentication method

### Usage exemples with environment variables

***Auto-login***
```
docker run --rm --name phpmyadmin -p 8080:8080 \
             -e PMA_HOST=mysql \
             -e PMA_USER=testUser \
             -e PMA_PASSWORD=PasSW0rD \
             noctuary/phpmyadmin
```   
In case *mysql* is a a running container, you can also use:   
```
docker run --rm --name phpmyadmin -p 8080:8080 \
             --link mysql:db \
             -e PMA_USER=testUser \
             -e PMA_PASSWORD=PasSW0rD \
             noctuary/phpmyadmin
```   
When accessing a MySQL/MariaDB external server, the port must be specified if not 3306 (default MySQL/MariaDB port):   
```
docker run --rm --name phpmyadmin -p 8080:8080 \
             -e PMA_HOST=mysql.example.com \
             -e PMA_PORT=3307 \
             -e PMA_USER=testUser \
             -e PMA_PASSWORD=PasSW0rD \
             noctuary/phpmyadmin
```   