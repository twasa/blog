---
title: "How to install and auto update Let's encrypt wildcard certs on Synology NAS with cloudflare DNS API"
date: 2018-07-05T02:25:04+08:00
draft: true
---

## requirements
- Synology ssh enabled and sudo permission
- Cloudflare API key

## Installation of acme.sh
```
$ sudo -i
$ wget https://github.com/Neilpang/acme.sh/archive/master.tar.gz
$ tar xvf master.tar.gz
$ cd acme.sh-master/
$ ./acme.sh --install --nocron --home /usr/local/share/acme.sh --accountemail "email@example.com"
```

## Configuring DNS
For CloudFlare, we will set two environment variables that acme.sh (specifically, the dns_cf script from the dnsapi subdirectory) will read to set the DNS record. 
```
export CF_Key="MY_SECRET_KEY_SUCH_SECRET"
export CF_Email="email@example.com"
```

## Creating the certificate
```
$ cd /usr/local/share/acme.sh
$ export CERT_DOMAIN="your-domain.tld"
$ export CERT_DNS="dns_cf"
$ ./acme.sh --issue -d "$CERT_DOMAIN" --dns "$CERT_DNS" \
      --certpath /usr/syno/etc/certificate/system/default/cert.pem \
      --keypath /usr/syno/etc/certificate/system/default/privkey.pem \
      --fullchainpath /usr/syno/etc/certificate/system/default/fullchain.pem \
      --reloadcmd "/usr/syno/sbin/synoservicectl --reload nginx" \
      --dnssleep 20
```

## Configuring Certificate Renewal by /etc/crontab
```
0    10    2    *    *    root    /usr/local/share/acme.sh/acme.sh --cron --home /usr/local/share/acme.sh/
```