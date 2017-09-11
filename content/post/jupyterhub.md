---
title: "Jupyterhub"
date: 2017-09-11T17:05:01+08:00
tags: [ "Development" ]
draft: true
---
# JupyterHub on CentOS 7

## requirement
- a Linux/Unix based system
- Python 3.4 or greater
- wget
- pip
- npm


## install
- yum search python3
- yum -y install python3X
- yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel npm
- npm install -g configurable-http-proxy
- wget https://bootstrap.pypa.io/get-pip.py
- python3.X get-pip.py
- yum -y install python-devel python3X-devel
- pip3 install jupyterhub ipython[notebook]

## startup
- jupyterhub --ip 0.0.0.0 --port 8443 --ssl-key my_ssl.key --ssl-cert my_ssl.cert
- jupyterhub -f /path/to/jupyterhub_config.py

## config
- jupyterhub --generate-config
- vi jupyterhub_config.py
```
c.JupyterHub.ip = '0.0.0.0'
c.JupyterHub.port = 8443
c.JupyterHub.ssl_key = '/path/to/ssl.key'
c.JupyterHub.ssl_cert = '/path/to/ssl.cert'
c.Spawner.notebook_dir= '~/'
```

## systemd
- vi /usr/lib/systemd/system/jupyterhub.service

```
[Unit]
Description=Jupyter Notebook
After=network.target

[Service]
Type=simple
User=root
Group=root
Restart=always
RestartSec=10
WorkingDirectory=/etc/nagios/
ExecStart=/usr/bin/jupyterhub -f /root/jupyterhub_config.py

[Install]
WantedBy=multi-user.target
```

- systemctl reload jupyterhub
- systemctl enable jupyterhub
