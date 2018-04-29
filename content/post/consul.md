---
title: "Consul"
date: 2018-04-28T06:24:00+08:00
draft: true
---

# Consul

## Description
Consul has multiple components, but as a whole, it is a tool for discovering and configuring services in your infrastructure.

## Features
- Service Discovery: Clients of Consul can provide a service, such as api or mysql, and other clients can use Consul to discover providers of a given service. Using either DNS or HTTP, applications can easily find the services they depend upon.
- Health Checking: Consul clients can provide any number of health checks, either associated with a given service ("is the webserver returning 200 OK"), or with the local node ("is memory utilization below 90%"). This information can be used by an operator to monitor cluster health, and it is used by the service discovery components to route traffic away from unhealthy hosts.
- KV Store: Applications can make use of Consul's hierarchical key/value store for any number of purposes, including dynamic configuration, feature flagging, coordination, leader election, and more. The simple HTTP API makes it easy to use.
- Multi Datacenter: Consul supports multiple datacenters out of the box. This means users of Consul do not have to worry about building additional layers of abstraction to grow to multiple regions.

## Glossary
- Agent - An agent is the long running daemon on every member of the Consul cluster. It is started by running consul agent. The agent is able to run in either client or server mode. Since all nodes must be running an agent, it is simpler to refer to the node as being either a client or server, but there are other instances of the agent. All agents can run the DNS or HTTP interfaces, and are responsible for running checks and keeping services in sync.
- Client - A client is an agent that forwards all RPCs to a server. The client is relatively stateless. The only background activity a client performs is taking part in the LAN gossip pool. This has a minimal resource overhead and consumes only a small amount of network bandwidth.
- Server - A server is an agent with an expanded set of responsibilities including participating in the Raft quorum, maintaining cluster state, responding to RPC queries, exchanging WAN gossip with other datacenters, and forwarding queries to leaders or remote datacenters.
- Datacenter - While the definition of a datacenter seems obvious, there are subtle details that must be considered. For example, in EC2, are multiple availability zones considered to comprise a single datacenter? We define a datacenter to be a networking environment that is private, low latency, and high bandwidth. This excludes communication that would traverse the public internet, but for our purposes multiple availability zones within a single EC2 region would be considered part of a single datacenter.
- Consensus - When used in our documentation we use consensus to mean agreement upon the elected leader as well as agreement on the ordering of transactions. Since these transactions are applied to a finite-state machine, our definition of consensus implies the consistency of a replicated state machine. Consensus is described in more detail on Wikipedia, and our implementation is described here.
- Gossip - Consul is built on top of Serf which provides a full gossip protocol that is used for multiple purposes. Serf provides membership, failure detection, and event broadcast. Our use of these is described more in the gossip documentation. It is enough to know that gossip involves random node-to-node communication, primarily over UDP.
- LAN Gossip - Refers to the LAN gossip pool which contains nodes that are all located on the same local area network or datacenter.
- WAN Gossip - Refers to the WAN gossip pool which contains only servers. These servers are primarily located in different datacenters and typically communicate over the internet or wide area network.
- RPC - Remote Procedure Call. This is a request / response mechanism allowing a client to make a request of a server.

## Ports
- Server RPC (Default 8300). This is used by servers to handle incoming requests from other agents. TCP only.
- Serf LAN (Default 8301). This is used to handle gossip in the LAN. Required by all agents. TCP and UDP.
- Serf WAN (Default 8302). This is used by servers to gossip over the WAN to other servers. TCP and UDP.
- CLI RPC (Default 8400). This is used by all agents to handle RPC from the CLI. TCP only.
- HTTP API (Default 8500). This is used by clients to talk to the HTTP API. TCP only.
- DNS Interface (Default 8600). Used to resolve DNS queries. TCP and UDP.

## Syntax
- Usage
```
consul [--version] [--help] <command> [<args>]
```

### commands
- version: Prints the Consul version
- agent: Runs a Consul agent
- join: Tell Consul agent to join cluster
- members: Lists the members of a Consul cluster
- reload: Triggers the agent to reload configuration files
- leave: Gracefully leaves the Consul cluster and shuts down
- validate: Validate config files/directories
- info: Provides debugging information for operators.

#### agent command args
- datacenter: Datacenter of the agent.
- dev: Starts the agent in development mode.
- data-dir:  Path to a data directory to store agent state.
- config-file: A configuration file to load
- config-dir: Path to a directory to read configuration files from in '.json', Can be specified multiple times.
- node: Name of this node. Must be unique in the cluster.
- bind: The address that should be bound to for internal cluster communications. By default, this is "0.0.0.0", if there was multi private ip, this args must be config
- http-port: Sets the HTTP API port to listen on.
- dns-port: DNS port to use.
- server: used to control if an agent is in server or client mode. When provided, an agent will act as a Consul server. Each Consul cluster must have at least one server and ideally no more than 5 per datacenter.
- client: The address to which Consul will bind client interfaces, including the HTTP and DNS servers. By default, this is "127.0.0.1"
- datacenter: controls the datacenter in which the agent is running. If not provided, it defaults to "dc1".
- ui: Enables the built-in web UI server and the required HTTP routes. This eliminates the need to maintain the Consul web UI files separately from the binary.
- log-level: Log level of the agent
- bootstrap-expect: hints to the Consul server the number of additional server nodes we are expecting to join.
- enable-script-checks: controls whether health checks that execute scripts are enabled on this agent, and defaults to false so operators must opt-in to allowing these.
- ui: Enables the built-in web UI server and the required HTTP routes. This eliminates the need to maintain the Consul web UI files separately from the binary.
- encrypt: Specifies the secret key to use for encryption of Consul network traffic. This key must be 16-bytes that are Base64-encoded.
- key_file
- cert_file
- ca_file
- retry-join: allows retrying a join if the first attempt fails.
```
consul agent -retry-join "provider=aws tag_key=... tag_value=..."
consul agent -retry-join "provider=gce project_name=... tag_value=..."
consul agent -retry-join "provider=aliyun region=... tag_key=consul tag_value=... access_key_id=... access_key_secret=..."
```

### Create the Necessary Directory and System Structure
- Create the user now by typing:
```
adduser consul
```

- create the configuration hierarchy
```
mkdir -p /etc/consul.d/{bootstrap,server,client}
```

- create a location where consul can store persistent data
```
mkdir ./data
chown consul:consul ./data
```

### Setting up consul server cluster
- server1 + bootstrap + ui
```
consul keygen
X4SYOinf2pTAcAHRhpj7dA==

consul agent -server -client=0.0.0.0 -bootstrap-expect=3 -datacenter=gcp-asia-east -node=node1 -data-dir="/opt/consul/data" -config-dir="./conf" -enable-script-checks=true -encrypt="X4SYOinf2pTAcAHRhpj7dA=="

or using config file

consul agent -server -config-dir="./conf"

#./conf/default.json
{
  "client": "0.0.0.0",
  "ports": {
      "https": 8080
  }
  "datacenter": "gcp-asia-east",
  "data_dir": "/opt/consul/data",
  "enable-script-checks": "true",
  "log_level": "INFO",
  "node_name": "mycluster",
  "server": true,
  "encrypt": "X4SYOinf2pTAcAHRhpj7dA==",
  "key_file": "/etc/pki/tls/private/my.key",
  "cert_file": "/etc/pki/tls/certs/my.crt",
  "ca_file": "/etc/pki/tls/certs/ca-bundle.crt"
}
```

- in server2 and server 3
```
consul agent -node=node2 -data-dir="/opt/consul/data" -config-dir="./conf" -enable-script-checks=true -retry-join 
consul agent -node=node3 -data-dir="/opt/consul/data" -config-dir="./conf" -enable-script-checks=true -retry-join 
```


## service discovery
- Defining a Service
```
echo '{"service": {"name": "web", "tags": ["rails"], "port": 80, "interval": "10s"}}' | sudo tee ./conf/web.json

```

- Querying Services
```
dig @127.0.0.1 -p 8600 web.service.consul

;; QUESTION SECTION:
;web.service.consul.        IN  A

;; ANSWER SECTION:
web.service.consul. 0   IN  A   172.20.20.11

dig @127.0.0.1 -p 8600 rails.web.service.consul

;; QUESTION SECTION:
;rails.web.service.consul.      IN  A

;; ANSWER SECTION:
rails.web.service.consul.   0   IN  A   172.20.20.11

dig @127.0.0.1 -p 8600 web.service.consul SRV

;; QUESTION SECTION:
;web.service.consul.        IN  SRV

;; ANSWER SECTION:
web.service.consul. 0   IN  SRV 1 1 80 Armons-MacBook-Air.node.dc1.consul.

;; ADDITIONAL SECTION:
Armons-MacBook-Air.node.dc1.consul. 0 IN A  172.20.20.11
```