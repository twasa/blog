---
title: "Docker Memo(drafting)"
date: 2017-09-22T10:57:01+08:00
tags: [ "Docker" ]
categories: [ "Virtualization", "Container" ]
draft: true
---


# Docker

## Description
- is an open platform for developers and sysadmins to build, ship, and run distributed applications, whether on laptops, data center VMs, or the cloud
- Containers vs. virtual machines
 - Virtual Machine diagram

![Alt text](https://www.docker.com/sites/default/files/VM@2x.png "Virtual Machine")

 - Container diagram

![Alt text](https://www.docker.com/sites/default/files/Container@2x.png "Virtual Machine")

## docker concept
- Image : a lightweight, stand-alone, executable package that includes everything needed to run a piece of software, including the code, a runtime, libraries, environment variables, and config files.

- Container : a runtime instance of an imageâ€”what the image becomes in memory when actually executed. It runs completely isolated from the host environment by default, only accessing host files and ports if configured to do so.

- registries : a place to store and distribute Docker images, like Docker Hub

- Repository : a collection of different versions for a single Docker image

- Dockerfile : a text document that contains all the commands a user could call on the command line to assemble an image. Using docker build users can create an automated build that executes several command-line instructions in succession.

- Docker Machine : a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with docker-machine commands. You can use Machine to create Docker hosts on your local Mac or Windows box, on your company network, in your data center, or on cloud providers like Azure, AWS, or Digital Ocean.

- Compose : a tool for defining and running multi-container Docker applications

- Docker Swarm (1.12.0 or later) : enables you to create a cluster of one or more Docker Engines called a swarm. A swarm consists of one or more nodes: physical or virtual machines running Docker Engine 1.12 or later in swarm mode.
![Alt text](https://docs.docker.com/engine/swarm/images/swarm-diagram.png "Virtual Machine")

## Requirement
- 64bit environment
- Linux kernel > 3.10

## installation
- reference https://docs.docker.com/engine/installation/
- Ubuntu
```
atp-get update
curl -fsSL https://get.docker.com/ | sh
```

- CentOS 6
```
yum install epel-release
yum install docker-io
```

- CentOS 7
```
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yum install docker-ce
systemctl enable docker
systemctl start docker
```

## commands and syntax
- Usage:

```
docker [OPTIONS] COMMAND [ARG...]
docker [ --help | -v | --version ]

A self-sufficient runtime for containers.

Options:
      --config string      Location of client config files (default "/root/.docker")
  -D, --debug              Enable debug mode
      --help               Print usage
  -H, --host value         Daemon socket(s) to connect to (default [])
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/root/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/root/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/root/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit
```

- Commands

| Command | Description |
|---|---|
|docker attach | Attach local standard input, output, and error streams to a running container|
|docker build | Build an image from a Dockerfile|
|docker checkpoint | Manage checkpoints|
|docker commit | Create a new image from a container’s changes|
|docker config | Manage Docker configs|
|docker container | Manage containers|
|docker cp | Copy files/folders between a container and the local filesystem|
|docker create | Create a new container|
|docker deploy | Deploy a new stack or update an existing stack|
|docker diff | Inspect changes to files or directories on a container’s filesystem|
|docker events | Get real time events from the server|
|docker exec | Run a command in a running container|
|docker export | Export a container’s filesystem as a tar archive|
|docker history | Show the history of an image|
|docker image | Manage images|
|docker images | List images|
|docker import | Import the contents from a tarball to create a filesystem image|
|docker info | Display system-wide information|
|docker inspect | Return low-level information on Docker objects|
|docker kill | Kill one or more running containers|
|docker load | Load an image from a tar archive or STDIN|
|docker login | Log in to a Docker registry|
|docker logout | Log out from a Docker registry|
|docker logs | Fetch the logs of a container|
|docker network | Manage networks|
|docker node | Manage Swarm nodes|
|docker pause | Pause all processes within one or more containers|
|docker plugin | Manage plugins|
|docker port | List port mappings or a specific mapping for the container|
|docker ps | List containers|
|docker pull | Pull an image or a repository from a registry|
|docker push | Push an image or a repository to a registry|
|docker rename | Rename a container|
|docker restart | Restart one or more containers|
|docker rm | Remove one or more containers|
|docker rmi | Remove one or more images|
|docker run | Run a command in a new container|
|docker save | Save one or more images to a tar archive (streamed to STDOUT by default)|
|docker search | Search the Docker Hub for images|
|docker secret | Manage Docker secrets|
|docker service | Manage services|
|docker stack | Manage Docker stacks|
|docker start | Start one or more stopped containers|
|docker stats | Display a live stream of container(s) resource usage statistics|
|docker stop | Stop one or more running containers|
|docker swarm | Manage Swarm|
|docker system | Manage Docker|
|docker tag | Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE|
|docker top | Display the running processes of a container|
|docker unpause | Unpause all processes within one or more containers|
|docker update | Update configuration of one or more containers|
|docker version | Show the Docker version information|
|docker volume | Manage volumes|
|docker wait | Block until one or more containers stop, then print their exit codes|


### commands examples
- docker run hello-world
```
docker run hello-world
```

- check docker version
```
docker --version
```

- check docker images
```
docker images
```

### Using Dockerfile
- Create your project directory
- Change directories (cd) into the directory
- create a file called Dockerfile, sample code as below

```
# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```
- Create a requirements.txt

```
Flask
Redis
```

- Create a app.py

```
from flask import Flask
from redis import Redis, RedisError
import os
import socket

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

```

- Build the app

```
docker build -t friendlyhello .
```

- check the docker image

```
docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
friendlyhello           latest              2af32fdfad1d        9 seconds ago       195.4 MB
docker.io/python        2.7-slim            8b88f06b72d7        8 days ago          183.6 MB
docker.io/hello-world   latest              05a3bd381fc2        2 weeks ago         1.84 kB
```

- run the app

```
docker run -p 4000:80 friendlyhello
```

- run the app in the background, in detached mode:

```
docker run -d -p 4000:80 friendlyhello
```

- get running container

```
docker ps
docker container ls #v1.3 or upper only
```

- stop the running container

```
docker stop <CONTAINER ID>
```

- Tag the image

```
docker tag image username/repository:tag
docker tag friendlyhello william/get-started:part2
```

- Remove one or more images

```
docker rmi <container id>
docker image rm <image id>
```

- Publish the image

```
docker push username/repository:tag
```

- Pull and run the image from the remote repository

```
docker run -p 4000:80 username/repository:tag
```

### Using docker-compose for docker stack deploy
- create a docker-compose.yml tells Docker to do the following:
- Pull the image we uploaded in step 2 from the registry.
- Run 2 instances of that image as a service called web, limiting each one to use, at most, 10% of the CPU (across all cores), and 50MB of RAM.
- Immediately restart containers if one fails.
- Map port 4000 on the host to web’s port 80.
- Instruct web’s containers to share port 80 via a load-balanced network called webnet. (Internally, the containers themselves will publish to web’s port 80 at an ephemeral port.)
- Define the webnet network with the default settings (which is a load-balanced overlay network).

```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: william/get-started:part2
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:

```

- for load-balance, run swarm init first
```
docker swarm init
```

- run docker stack
```
docker stack deploy -c docker-compose.yml getstartedlab
```

- Get the service ID for the one service in our application:
```
docker service ls
```

- List the tasks
```
docker service ps <service>
```

- check task information
```
docker inspect --format='{{.Status.ContainerStatus.ContainerID}}' <task or containerid>
```

- Scale the app by changing the replicas value in docker-compose.yml, saving the change, and re-running the docker stack deploy command:
```
docker stack deploy -c docker-compose.yml getstartedlab
```

- Take down the app and the swarm
```
docker stack rm getstartedlab
docker swarm leave --force
```

### install docker-machine
- install
```
curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
chmod +x /tmp/docker-machine &&
sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
```

- check version
```
docker-machine version
```

- uninstall
```
rm $(which docker-machine)
```

### Swarm clusters
- TCP port 2376 for secure Docker client communication. This port is required for Docker Machine to work. Docker Machine is used to orchestrate Docker hosts.

- TCP port 2377. This port is used for communication between the nodes of a Docker Swarm or cluster. It only needs to be opened on manager nodes.

- TCP and UDP port 7946 for communication among nodes (container network discovery).

- UDP port 4789 for overlay network traffic (container ingress networking).

- Manager : 
- Worker(Node) : 