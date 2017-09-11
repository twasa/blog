---
title: "Linux openssl"
date: 2017-09-11T17:12:29+08:00
draft: true
---

## create private key
```
openssl genrsa -out server.key 2048
```

## create Certificate Signing Request
```
openssl req -sha512 -new -key server.key -out server.csr -subj "/C=TW/ST=Taipei/L=Taipei/O=example/OU=Personal/CN=www.example.com"
```

## check csr info
```
openssl req -in server.csr -noout -text
```

## Self-Sign Certificate
```
openssl x509 -sha512 -req -days 3650 -in server.csr -signkey server.key -out server.crt
```

## encrypt private key
## -a 表示檔案使用 base64 編碼
## -salt 加雜湊值，增加安全性
```
openssl aes-256-cbc -a -salt -in server.key -out server.encrypt.key
```