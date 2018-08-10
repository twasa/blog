---
title: "Mongodb basic"
date: 2017-09-11T15:54:35+08:00
tags: [ "Mongodb" ]
categories: [ "Database", "NoSQL" ]
draft: true
---
# MonboDB

## install

- Create a /etc/yum.repos.d/mongodb-org-3.4.repo

```txt
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
```

- yum

```shell
yum install -y mongodb-org
```

## config

- default path /etc/mongod.

```txt
# security
db.createUser(
   {
     user: "帳號",
     pwd: "密碼",
     roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
   }
)
security.authorization : enabled
```

## selinux

```txt
semanage port -a -t mongod_port_t -p tcp 27017
```

## shell

### connection

```shell
mongo --port 27017 -u "unitadmin" -p "xyz123" --authenticationDatabase "test"
```

### list current using db

```shell
db
```

### 列出資料庫清單

```shell
show dbs
```

### 切換資料庫

```shell
use 資料庫名稱
```

### 驗證

```shell
db.auth('account', 'password')
```

### 顯示協助訊息

```shell
help
```

### 列出資料表

```shell
show collections
```

### 列出collection 資料筆數

```shell
db.products.count()
```

### CRUD

```shell
example:
db.collectionname.find(
  {name: "william"},    #query
  {Name:1, address:1}   #projection
  ).limit(5)            #modifier
```

### mongo {{ DB_NAME }} --eval "db.dropDatabase()" 移除 database。 或者下面這種方式：

```shell
> use mydb;
> db.dropDatabase();
```

### 離開mongo Shell

```shell
exit
```

### 直接執行

```shell
mongo {{ DB_NAME }} --eval "語法"
mongo test --eval "db.egame.findOne()"
mongo test --eval 'db.egame.remove({"createDateTime" : {$lt : ISODate("2017-06-10T13:56:00.001Z")}})'
```

### 使用js file帶入語法

```shell
mongo < script.js
//script.js 內容
db.mycollection.findOne()
db.getCollectionNames().forEach(function(collection) {
  print(collection);
});
```

## account and permission

### show accounts

```shell
show users
```

### create account for db backup

```shell
use 要備份的資料庫名稱
db.createUser(
  {
    user: "帳號",
    pwd: "密碼",
    roles: [ { role: "backup", db: "admin" } ]
  }
)
```

### for db only account

```shell
use 資料庫名稱
db.createUser({
  user: "帳號",
  pwd: "密碼",
  roles: [
    { role: "userAdmin", db: "資料庫名稱" },
    { role: "readWrite", db: "資料庫名稱" },
    { role: "dbAdmin", db: "資料庫名稱" }
  ]
});

db.createUser({
  user: "帳號",
  pwd: "密碼",
  roles: [
    { role: "readWrite", db: "資料庫名稱" },
  ]
});

db.updateUser(
   "betadmin",
   {
     roles : [
     { role: "userAdmin", db: "資料庫名稱" },
     { role: "readWrite", db: "資料庫名稱" },
     { role: "dbAdmin", db: "資料庫名稱" }
             ],
     pwd: "密碼"
    }
)


db.removeUser(帳號)
```

## enable on config file

```yaml
security:
  authorization: enabled
```

## compare with relational database

|   MongoDB   | MySQL  |
| ----------- | ------ |
| collections | tables |
| documents   | rows   |

## backup and restore

- backup

```shell
mongodump --gzip --archive=backup-file-name --db db-name --collection collection-name -q ""
mongodump -d 資料庫名稱 -c egame -q '{"createDateTime":{$gte:ISODate("2017-06-11T00:00:00.000Z")}}' --gzip --archive=/tmp/backup.tgz

--out filename

mongodump -u$mongo_user -p$mongo_secret \
-d $db -c $collection \
--queryFile $DIR/query.json \
--gzip --archive="/tmp/${collection}-backup-${dumpdate}.tgz"

query.json 內容
{"createDateTime":{$gte:ISODate("YYYY-MM-DDT00:00:00.000Z")}}
```

- restore

```shell
mongorestore --db db-name --collection collection-name filename
mongorestore --archive=filename --gzip
```

## Roles

- refernece https://docs.mongodb.com/manual/reference/built-in-roles/

```txt
read：允許帳號讀取指定資料庫
readWrite：允許帳號讀寫指定資料庫
backup,retore:允許備份、還原，在db.createUser()方法中roles里面的db必須是admin資料庫，不然會錯誤
dbAdmin：允許帳號在指定資料庫中執行管理函數，如索引建立、删除，查看統計或訪問system.profile
userAdmin：允許帳號向system.users這個collection寫入，可以找指定資料庫裡建立、刪除與管理帳號
clusterAdmin：只在admin資料庫中可用，赋予帳號所有分片和复制集相关函数的管理權限。
readAnyDatabase：只在admin資料庫中可用，赋予用户所有資料庫的讀取權限
readWriteAnyDatabase：只在admin資料庫中可用，赋予用户所有資料庫的读写權限
userAdminAnyDatabase：只在admin資料庫中可用，赋予用户所有資料庫的userAdmin權限，
dbAdminAnyDatabase：只在admin資料庫中可用，赋予用户所有資料庫的dbAdmin權限。
root：只在admin資料庫中可用。等於最高權限帳號
```

## remove

```shell
yum erase $(rpm -qa | grep mongodb-org)
rm -r /var/log/mongodb
rm -r /var/lib/mongo
```