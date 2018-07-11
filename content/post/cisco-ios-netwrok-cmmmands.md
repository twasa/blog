---
title: "Cisco Ios Netwrok Cmmmands"
date: 2017-09-11T13:00:03+08:00
tags: [ "Cisco" ]
categories: [ "Network" ]
draft: true
---


## 狀態查看
- show startup-config
- show running-config
- show version
- show vlan id
- show ip route
- show ip nhrp
- show crypto engine connection active
- sh run | inc ip route
- 查看連線的TCP session
```
show ip sockets detail
```
- 查IP流量
```
conf t
interface xxx
ip accounting
end
sh ip accounting
備註, 查完記得no掉, 否則會增加cpu的負擔!
conf t
interface xxx
no ip accounting
```

## 基本操作
- 從User Mode進入Privileged Mode
- enable
- 從Privileged Mode進入Global Configuration Mode
- configure terminal
- 儲存設定
```
write
or 
copy running-config startup-config
```

## 設定
- 介面IP設定
- interface fastEthernet 0/0
- ip address IP位置 子網路遮罩
- no shutdown

- 路由設定
- ip route IP位置 子網路遮罩 路由IP位置
- ip route IP位置 子網路遮罩 介面名稱

- PPPoE設定
- interface Dialer1
- mtu 1492
- ip address negotiated
- ip nat outside
- no ip virtual-reassembly
- encapsulation ppp
- ip tcp adjust-mss 1300
- dialer pool 1
- dialer-group 1
- ppp pap sent-username XXXX password 0 XXXX
- exit
- interface FastEthernet x/x
- description PPPOE
- no ip address
- duplex auto
- speed auto
- pppoe enable group global
- pppoe-client dial-pool-number 1

## 連線管理設定
- line vty 0 4
- tra in telnet ssh

## AAA設定
- aaa new-model
- aaa authentication login AAAXXX local group radius
- aaa authorization console
- aaa authorization exec AAAXXX  local group radius
- aaa session-id common
- radius-server host A.B.C.D auth-port XXXX acct-port XXXX
- radius-server key 7 XXXXXX
- line vty 0 4
- authorization exec AAAXXX
- login authentication AAAXXX
- exit
- line vty 5 15
- authorization exec AAAXXX
- login authentication AAAXXX
- exit
- ip radius source-interface 介面名稱

## 權限設定
- privilege exec level 7 telnet
- privilege exec level 7 ping ip
- privilege exec level 7 ping
- privilege exec level 7 show startup-config
- privilege exec level 7 show running-config
- privilege exec level 7 show

## config file backup to FTP 設定
- archive
- path ftp://10.192.1.139/SOME_PATH/$h
- write-memory
- time-period 1440
- exit
- ip ftp source-interface 介面名稱
- ip ftp username XXXX
- ip ftp password 7 XXXXXXXX
- exit

## 連線測試
- ping 10.192.1.4 source 介面名稱
- ping 10.192.1.139 source 介面名稱

## NetFlow CE 設定
- snmp-server community cnlinktw RO
- show ip flow export : Shows the current NetFlow configuration
- interface Loopback0
- description Netflow
- ip address A.B.C.D 255.255.255.255
- ip flow-export source Loopback0
- ip flow-export version 5
- ip flow-export destination collectorIP位址collectorPort

## Router GRE Tunnel 設定
- interface Tunnel xxx
- description "Primary Tunnel description"
- ip address IP位址 子網路遮罩
- tunnel source IP位址
- tunnel destination IP位址

## NHRP CE 設定
- interface Tunnel1009
- description "NHRP description"
- ip address NHCsPrivateIP位址 255.255.255.252
- no ip redirects
- ip nhrp authentication tp001542
- ip nhrp map 10.195.252.26 NHSsPublicIP位址
- ip nhrp map multicast NHSsPublicIP位址
- ip nhrp network-id 1542
- ip nhrp holdtime 60
- ip nhrp nhs NHSsIP
- ip tcp adjust-mss 1460
- tunnel source 介面名稱
- tunnel mode gre multipoint
- tunnel key 1542