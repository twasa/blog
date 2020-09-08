---
title: "How to install and auto update Let's encrypt wildcard certs on Synology NAS with Route53 DNS"
date: 2018-07-05T02:25:04+08:00
draft: true
---

## requirements

- Synology ssh enabled and sudo permission
- Cloudflare API key

## Installation of acme.sh

```shell
sudo -i
wget https://github.com/Neilpang/acme.sh/archive/master.tar.gz
tar xvf master.tar.gz
cd acme.sh-master/
./acme.sh --install --nocron --home /usr/local/share/acme.sh --accountemail "email@example.com"
```

## Configuring DNS

For CloudFlare, we will set two environment variables that acme.sh (specifically, the dns_cf script from the dnsapi subdirectory) will read to set the DNS record. 

```shell
export AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="AWS_SECRET_ACCESS_KEY"
```

## Creating the certificate

```shell
$ cd /usr/local/share/acme.sh
$ export CERT_DOMAIN="your-domain.tld"
$ export CERT_DNS="dns_aws"
$ ./acme.sh --issue -d "$CERT_DOMAIN" --dns "$CERT_DNS" \
      --certpath /usr/syno/etc/certificate/system/default/cert.pem \
      --keypath /usr/syno/etc/certificate/system/default/privkey.pem \
      --fullchainpath /usr/syno/etc/certificate/system/default/fullchain.pem \
      --capath /usr/syno/etc/certificate/system/default/chain.pem \
      --reloadcmd "cp -a /usr/syno/etc/certificate/system/default/* `find /usr/syno/etc/certificate/_archive/ -maxdepth 1 -mindepth 1 -type d` && /usr/syno/sbin/synoservicectl --reload nginx && /usr/syno/sbin/synoservicecfg --reload httpd-sys" \
      --dnssleep 20 \
      --config-home "/path/to/save/acmeconfigs/"
```

## Configuring Certificate Renewal by /etc/crontab

```conf
0    10    2    *    *    root    /usr/local/share/acme.sh/acme.sh --cron --home /path/to/save/acmeconfigs/
```