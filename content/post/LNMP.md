---
title: "CentOS7 Linux Nginx MariaDB PHP"
date: 2017-09-11T10:14:51+08:00
tags: [ "Linux", "Webserver" ]
draft: true
---

# Build a Linux, Nginx, MariaDB, PHP environment in CentOS 7

## install
```
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum install nginx php php-fpm mariadb mariadb-server
```

## firewalld for http, https access only
```
firewall-cmd --zone=public --list-all
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
firewall-cmd --zone=public --list-all
```

## Nginx config

### basic config, edit /etc/nginx/nginx.conf
```
user  nginx;
worker_processes  2; #by your cpu

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024; 
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;
    server_tokens   off;
    keepalive_timeout  65;

    gzip  on;
    include /etc/nginx/conf.d/*.conf;
}
```

### config for pass the PHP scripts to FastCGI server php-fpm using file socket in /etc/nginx/conf.d/default.conf
```
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;
    access_log  /var/log/nginx/host.access.log  main;
    root   /usr/share/nginx/html;
    index  index.html index.php index.htm;

    location / {

    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ \.php$ {
        fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

# session path
# for mod_php, see /etc/httpd/conf.d/php.conf
# for php-fpm, see /etc/php-fpm.d/*conf
```

## PHP config in /etc/php.ini
```
cgi.fix_pathinfo=0
```

## PHP-FPM config in /etc/php-fpm.d/www.conf
listen = /var/run/php-fpm/php-fpm.sock
listen.owner = nobody
listen.group = nobody
listen.mode = 0666
user = nginx
group = nginx

## MariaDB config
reference to https://twasa.github.io/post/my-db/

## Verify
### create /usr/share/nginx/html/info.php
```
<?php
phpinfo();
?>
```

## web permission for nginx
```
chown -R nginx:nginx /usr/share/nginx/html/
```

## selinux
```
chcon --reference=/usr/share/nginx/html/index.html /usr/share/nginx/html/*
```

### visit http://server/info.php to Verify