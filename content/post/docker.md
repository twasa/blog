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

## Requirement
- 64bit environment
- Linux kernel > 3.10

## installation
- Ubuntu
```
atp-get update
curl -fsSL https://get.docker.com/ | sh
```

- CentOS 6
```
yum install epel
yum install docker-io
```

- CentOS 7
```
yum install docker
```

## command and syntax


