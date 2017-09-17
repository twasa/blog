---
title: "Apache Tomcat"
date: 2017-09-11T12:34:25+08:00
tags: [ "Webserver", "Apache", "Tomcat" ]
draft: true
---


## 參考文件
- https://tomcat.apache.org/tomcat-8.0-doc/index.html
- https://tomcat.apache.org/tomcat-8.0-doc/config/

## install java, check it running and version
```
yum install java-1.8.0-openjdk
or
curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm > jdk-8u112-linux-x64.rpm && rpm -Uvh jdk-8u112-linux-x64.rpm
java -version
```

## create a nologin user for running tomcat
```
useradd -s /sbin/nologin tomcat
```

## download from apache tomcat
```
cd /home/tomcat
wget http://apache.stu.edu.tw/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz
tar zxvf apache-tomcat-8.0.28.tar.gz
```

## setenv.sh
- 設定運行參數如記憶體、垃圾回收機制等參數
```
JAVA_OPTS="-Dfile.encoding=UTF-8 -Dnet.sf.ehcache.skipUpdateCheck=true -server -Xms1024m -Xmx1024m -Xmn128m -Xss2m -XX:+UseParallelGC"
```

- 設定Tomcat JMX remote 監控
```
CATALINA_OPTS="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8888 -Dcom.sun.management.jmxremote.rmi.port=8889"
```

## catalina.properties
- 設定增加讓webapps可讀取property檔路徑

```
common.loader="${catalina.base}/lib","${catalina.base}/lib/*.jar","${catalina.home}/lib","${catalina.home}/lib/*.jar","${catalina.home}/路徑"
```

## server.xml
- 設定webapp可存取系統目錄
- 設定SSL

```
    <Connector port="4433" maxThreads="200" scheme="https" secure="true" SSLEnabled="true"
    keystoreFile="/path/to/your/keyfile" keystorePass="密碼" clientAuth="false" sslProtocol="TLS"/>
```

## tomcat-users.xml
- 設定使用者或manager-script(deploy server using like jenkins)可存取Manager頁面

```
  <role rolename="manager-gui" />
  <role rolename="manager-script" />
  <role rolename="manager-jmx" />
  <user username="帳號" password="密碼" roles="manager-gui" />
  <user username="帳號" password="密碼" roles="standard,manager-script,manager-jmx" />

roles 說明
manager-gui - allows access to the HTML GUI and the status pages
manager-script - allows access to the text interface and the status
manager-jmx - allows access to the JMX proxy and the status
manager-status - allows access to the status pages only
```

## context.xml
- 設定資料庫連線位址、Port、帳號、密碼.....

```
    <Resource name="jdbc/shacomBid" auth="Container" type="javax.sql.DataSource" maxActive="10" maxIdle="5" maxWait="10000" username="帳號" password="密碼" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://DBFQDN:3306/bid?characterEncoding=UTF-8&allowMultiQueries=true&useUnicode=true"/>
```

## 設定Manager頁面IPv4網段存取限制
```
cp -p /home/apache-tomcat-X.X.XX/webapps/host-manager/manager.xml /home/apache-tomcat-X.X.XX/conf/Catalina/localhost/
vi /home/apache-tomcat-X.X.XX/conf/Catalina/localhost/manager.xml
<Context docBase="${catalina.home}/webapps/manager"
privileged="true" antiResourceLocking="false" antiJARLocking="false">
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="A\.B\.C\.\d+|127\.\d+\.\d+\.\d+" denyStatus="404" />

cp -p /home/apache-tomcat-X.X.XX/webapps/host-manager/manager.xml /home//apache-tomcat-X.X.XX/conf/Catalina/localhost/ROOT.xml
vi /home/apache-tomcat-X.X.XX/conf/Catalina/localhost/ROOT.xml
<Context docBase="${catalina.home}/webapps/ROOT"
privileged="true" antiResourceLocking="false" antiJARLocking="false">
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="A\.B\.C\.\d+|127\.\d+\.\d+\.\d+" denyStatus="404" />
```

## 設定manager deploy war檔案大小
```
    vi /home/apache-tomcat-X.X.XX/webapps/manager/WEB-INF/web.xml

　　　　    <multipart-config>
　　　　      <max-file-size>152428800</max-file-size>
　　　　      <max-request-size>152428800</max-request-size>
　　　　      <file-size-threshold>0</file-size-threshold>
　　　　    </multipart-config>

```

