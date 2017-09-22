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
- Container : a runtime instance of an image—what the image becomes in memory when actually executed. It runs completely isolated from the host environment by default, only accessing host files and ports if configured to do so.
- registries : a place to store and distribute Docker images, like Docker Hub
- Repository : a collection of different versions for a single Docker image
- Compose : a tool for defining and running multi-container Docker applications
- Docker Machine : a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with docker-machine commands. You can use Machine to create Docker hosts on your local Mac or Windows box, on your company network, in your data center, or on cloud providers like Azure, AWS, or Digital Ocean.
- Dockerfile : a text document that contains all the commands a user could call on the command line to assemble an image. Using docker build users can create an automated build that executes several command-line instructions in succession.

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
yum install docker
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

### commands examples
- docker hello world
```
docker run hello-world
```

- check docker version
```
docker --version
```

