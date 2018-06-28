# Laravel Docker

This README file is a documentation about how to create docker containers based on images for Laravel applications.
<br />Also, it shows how to create and configure a MySQL Docker container attached to application container.
 
### Cloning the project
    
    git clone https://github.com/reivaldo/laravel-docker.git
   
### Building a custom image
Run the command bellow to build a new one
    
    cd laravel-docker
    docker build -t php7.1-apache2 .
   
### Checking images

    docker images

You should have a result like the one below:

    REPOSITORY         TAG                 IMAGE ID            CREATED             SIZE
    php7.1-apache2      latest             2800072b8b21        9 months ago        402MB


## Database container based on remote official MySQL 5.7 image ##

### Creating a new directory for mysql files in $PWD/mysql
It will save all databases files in {USER_FOLDER}/mysql instead saving the ones inside your docker container.
     
    cd ~
    mkdir -p $PWD/mysql

### Running the docker command to create the mysql container

    docker run -d  -v $PWD/mysql:/var/lib/mysql --name dbserver -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret mysql:5.7 --sql-mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"

### Checking containers

    docker ps

You should have a result like the one below:

    CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                    NAMES
    029834391ec3        mysql:5.7                 "docker-entrypoint..."   7 weeks ago         Up 3 days           0.0.0.0:3306->3306/tcp   dbserver


## Laravel application container based on php7.1-apache2 docker image ##


### Running the docker command to create the Laravel application container
You must be inside the project folder. Eg. : /home/{USER_FOLDER}/Projects/{PROJECT_FOLDER}

    docker run -d -v $PWD:/var/www/html -p 8000:80 --name={APP_CONTAINER} --link dbserver -e DB_HOST=dbserver php7.1-apache2


### Checking containers

    docker ps

You should have a result like the one below:

    CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                    NAMES
    e4a4fcaa0010        php7.1-apache2           "docker-php-entrypoi…"    7 weeks ago         Up 2 days           0.0.0.0:8000->80/tcp     {APP_CONTAINER}
    029834391ec3        mysql:5.7                "docker-entrypoint..."    7 weeks ago         Up 3 days           0.0.0.0:3306->3306/tcp   dbserver
    
    
### Setting application permissions

    sudo chgrp -R www-data $(pwd)/storage $(pwd)/bootstrap/cache
    sudo chmod -R ug+rwx $(pwd)/storage $(pwd)/bootstrap/cache    
    
    
### Setting dbserver host name

Open the hosts file
    
    sudo nano /etc/hosts

Add the line below in the hosts file

    127.0.0.1  dbserver
    

### Configuring .env file

    DB_HOST=dbserver
    DB_DATABASE={DATABASE_NAME}
    DB_USERNAME=root
    DB_PASSWORD=secret
    
### Basic Docker commands

Listing only active containers

    docker ps
    
Including stopped containers

    docker ps -a
    
Accessing application container

    docker exec -it {APP_CONTAINER} bash
    
Logging application container

    docker logs --details {APP_CONTAINER}
    
Following logs for application container

    docker logs --details --follow {APP_CONTAINER}
    
Restarting application container

    docker restart {APP_CONTAINER}
    
See more in

    docker --help