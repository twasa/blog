---
title: "Apache Http Advanced"
date: 2017-09-11T15:50:54+08:00
tags: [ "Webserver", "Apache" ]
draft: true
---

# http rewrite
- syntax

```
<IfModule mod_rewrite.c>
RewriteEngine On #啟用
RewriteBase /路徑
RewriteCond 變數 開關
RewriteCond 變數 條件 [選項]
RewriteRule 規則 [選項]
</IfModule>
# 開關
on, off

# 選項
NC        (no case) 不區分大小寫
F         (force URL to be forbidden) 禁用URL,返回403HTTP狀態碼。
R[=code]  (force redirect) 強制外部重定向 code 預設302, 最好使用301
G         (force URL to be gone) 強制URL為GONE，返回410HTTP狀態碼
P         (force proxy) 強制使用代理轉發。
N         (next round) 重新從第一條規則開始運行重寫過程。
C         (chained with next rule) 與下一條規則關聯
AND
OR
#if ( (A OR B) AND (C OR D) )
RewriteCond A [or]
RewriteCond B [or]
RewriteCond C
RewriteCond D

L         (last rule) 表明當前規則是最後一條規則，停止分析以後規則的重寫

# 變數
- %{HTTP_HOST} !^www.example.com #聲明Client請求的主機中首碼不是 www.example.com
- %{HTTP_HOST} !^8.8.8.8 #聲明Client請求的主機中首碼不是 8.8.8.8
- %{HTTP_HOST} !^$  #聲明Client請求的主機中首碼不為空
- %{REQUEST_FILENAME}
- %{HTTP_USER_AGENT}
 - 條件
 "android|blackberry|googlebot-mobile|iemobile|ipad|iphone|ipod|opera mobile|palmos|webos" #手機瀏覽器
- %{REQUEST_URI} !^user.php$
- %{SERVER_PORT} ^443$
- %{HTTP_REFERER} example.com #從別的網站連過來

RewriteCond %{HTTP_HOST} !=""
RewriteCond %{HTTP_HOST} .
RewriteCond %{HTTP_HOST} !^$

RewriteCond {REQUEST_URI} !=/foo/bar
RewriteCond %{REQUEST_URI} !^/foo/bar$

RewriteCond {SERVER_PORT} =443
RewriteCond %{SERVER_PORT} ^443$

```

## en.example.com  to www.example.com

```
RewriteEngine on
RewriteCond %{HTTP_HOST} ^en.example.com [NC]
RewriteRule ^(.*) HTTP://www.example.com/ [L]
```

## How To Redirect Users To Mobile Or Normal Web Site Based On Device Using mod_rewrite

```
RewriteEngine On
RewriteCond %{HTTP_USER_AGENT} "android|blackberry|googlebot-mobile|iemobile|ipad|iphone|ipod|opera mobile|palmos|webos" [NC]
RewriteRule ^$ http://m.example.com/ [L,R=302]
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule (.*) https://%{HTTP_HOST}:443%{REQUEST_URI}
```

## Rewrite http to https
```
RewriteEngine On
RewriteCond %{HTTP:X-Forwarded-Proto} =http
RewriteRule . https://%{HTTP:Host}%{REQUEST_URI} [L,R=permanent]
```

## Rewrite http to https using http 301
```
RewriteEngine On
RewriteCond %{HTTP:X-Forwarded-Proto} ^http$
RewriteRule .* https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
```

## Rewrite http to https by port
```
RewriteEngine On
RewriteCond %{SERVER_PORT} !443
RewriteRule ^(/(.*))?$ https://%{HTTP_HOST}/$1 [R=301,L]
```

## Rewrite by detect url and user-agent
```

RewriteEngine On
RewriteCond %{HTTP_USER_AGENT} "android|blackberry|googlebot-mobile|iemobile|ipad|iphone|ipod|operamobile|palmos|webos" [AND,NC]
RewriteCond %{}%
RewriteCond
RewriteRule ^$ http://m.example.com/ [L,R=301]

```

## Reverse Proxy
```
ProxyRequests off
ProxyPreserveHost on
RequestHeader set X-Forwarded-Proto https
RequestHeader set X-Forwarded-Port 443
ProxyPass / http://127.0.0.1:8080/
ProxyPassReverse / http://127.0.0.1:8080/
```

## Reverse Proxy with VirtualHost
```
ProxyRequests off
<VirtualHost *:80>
ProxyVia On
ProxyPreserveHost On
RequestHeader set Host "t9admin.yolo168.xyz"
ServerName t9admin.yolo168.xyz

#ProxyPass / http://t9admin.04670467.com/
#ProxyPassReverse / http://t9admin.04670467.com/

ProxyPass / http://54.64.75.75/
ProxyPassReverse / http://54.64.75.75/

</VirtualHost>


關於 ProxyPassReverse
如果今天你的ProxyPass的設定為 ProxyPass /forum http://172.20.100.200/forum
可能會出現問題，因為rp會幫你把網址慮掉，也就是說
今天我 http://172.20.100.200/forum 事實上是轉到 http://172.20.100.220/forum
不過當我連 http://172.20.100.200/forum/blog 時，卻是轉到 http://172.20.100.220/blog
當網頁資料夾還有子目錄時，rp會自動蓋掉相同的path
所以要加上ProxyPassReverse這一行敘述，變成

ProxyPass /forum http://172.20.100.200/forum
ProxyPassReverse /forum http://172.20.100.200/forum
```

## compress
```
<ifmodule mod_deflate.c>
   # 壓縮率，建議值:6
   DeflateCompressionLevel 6
   AddOutputFilterByType DEFLATE text/plain
   AddOutputFilterByType DEFLATE text/html
   AddOutputFilterByType DEFLATE text/xml
   AddOutputFilterByType DEFLATE text/css
   AddOutputFilterByType DEFLATE text/javascript
   AddOutputFilterByType DEFLATE application/xhtml+xml
   AddOutputFilterByType DEFLATE application/xml
   AddOutputFilterByType DEFLATE application/rss+xml
   AddOutputFilterByType DEFLATE application/atom_xml
   AddOutputFilterByType DEFLATE application/x-javascript
   AddOutputFilterByType DEFLATE application/x-httpd-php
   AddOutputFilterByType DEFLATE image/svg+xml
</ifmodule>
```
## Multiple SSL Certificates
```
NameVirtualHost *:443

<VirtualHost *:443>
 ServerName www.yoursite.com
 DocumentRoot /var/www/site
 SSLEngine on
 SSLCertificateFile /path/to/www_yoursite_com.crt
 SSLCertificateKeyFile /path/to/www_yoursite_com.key
 SSLCertificateChainFile /path/to/DigiCertCA.crt
</VirtualHost>

<VirtualHost *:443>
 ServerName www.yoursite2.com
 DocumentRoot /var/www/site2
 SSLEngine on
 SSLCertificateFile /path/to/www_yoursite2_com.crt
 SSLCertificateKeyFile /path/to/www_yoursite2_com.key
 SSLCertificateChainFile /path/to/DigiCertCA.crt
</VirtualHost>
```

## expires
```
<IfModule mod_expires.c>
 ExpiresActive on
 ExpiresDefault "access plus 1 week"
​
 # CSS
 ExpiresByType text/css "access plus 1 week"
​
 # Data interchange
 ExpiresByType application/json "access plus 0 seconds"
 ExpiresByType application/xml "access plus 0 seconds"
 ExpiresByType text/xml "access plus 0 seconds"
​
 # Favicon (cannot be renamed!) and cursor images
 ExpiresByType image/x-icon "access plus 1 week"
​
 # HTML components (HTCs)
 ExpiresByType text/x-component "access plus 1 week"
​
 # HTML
 ExpiresByType text/html "access plus 0 seconds"
​
 # JavaScript
 ExpiresByType application/javascript "access plus 1 week"
​
 # Manifest files
 ExpiresByType application/x-web-app-manifest+json "access plus 0 seconds"
 ExpiresByType text/cache-manifest "access plus 0 seconds"
​
 # Media
 ExpiresByType audio/ogg "access plus 1 week"
 ExpiresByType image/gif "access plus 1 week"
 ExpiresByType image/jpeg "access plus 1 week"
 ExpiresByType image/png "access plus 1 week"
 ExpiresByType video/mp4 "access plus 1 week"
 ExpiresByType video/ogg "access plus 1 week"
 ExpiresByType video/webm "access plus 1 week"
 # Web feeds
 ExpiresByType application/atom+xml "access plus 1 hour"
 ExpiresByType application/rss+xml "access plus 1 hour"
</IfModule>
```

## HSTS( HTTP Strict Transport Security )
```
Header always set Strict-Transport-Security "max-age=31536000;includeSubdomains; preload"
```
