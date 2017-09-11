---
title: "MySQL and MariaDB memo"
date: 2017-09-11T12:24:19+08:00
tags: [ "Database", "MySQL", "MariaDB" ]
draft: true
---

## 第一次安裝完成，設定root的密碼
mysqladmin -u root -p '密碼'
or
mysql_secure_installation

## 重設root密碼
```
/etc/init.d/mysql stop
mysqld_safe --skip-grant-tables &
mysql -u root
mysql> use mysql;
mysql> UPDATE user SET Password=PASSWORD("密碼") WHERE User='root';
mysql> flush privileges;
mysql> quit
/etc/init.d/mysql stop
/etc/init.d/mysql start
```

## 連線管理資料庫
```
mysqladmin -u root -p
Enter password:  此時再輸入密碼(建議採用)

修改使用者密碼
方法一
使用有權限或要修改的使用者本身登入mysql
mysql> SET PASSWORD FOR '目標使用者'@'主機' = PASSWORD('密碼');
mysql> flush privileges

方法二
使用有權限的使用者登入mysql
修改使用者密碼，只改 root 的密碼，如果沒有用 where ，則表示改全部 user 的密碼
mysql> use mysql;
mysql> UPDATE user SET password=password('密碼') where user='root';
mysql> FLUSH PRIVILEGES;

上面是不分主機位址的修改，若要像方法一區分主機的話再加上Host條件，例如
mysql> UPDATE user SET Password=PASSWORD("密碼") WHERE User='root' AND Host = 'localhost';
mysql> FLUSH PRIVILEGES;

方法三
同樣利用mysqladmin指令可以修改root或其他使用者密碼，但該使用者必須有SUPER權限
mysqladmin -u 使用者 -p'舊密碼' password '新密碼'

忘記密碼重設
/etc/init.d/mysql stop
mysqld_safe --skip-grant-tables &
用上面方式啟動mysql後可以不用輸入密碼直接連入
mysql -u root
接者使用修改使用者密碼的方法二修改root密碼，最後重新啟動mysql
```

## 新增root可遠端存取 %表示任何IP或只接輸入IP
```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '密碼' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;

資料庫(DateBase)十五種權限
ALL PRIVILEGES、ALTER、CREATE、DELETE、DROP、FILE、INDEX、INSERT、PROCESS、REFERENCES、RELOAD、SELECT、SHUTDOWN、UPDATE、USAGE

資料表(Table)八種權限
SELECT、INSERT、UPDATE、DELETE、CREATE、DROP、INDEX、ALTER

資料欄(column)三種權限
SELECT INSERT UPDATE
```

## 查詢現有User
```
select user from mysql.user;
```

## 查詢MySQL 對 此帳號 開放(GRANT)哪些權限
```
查詢 某 User 的權限

SELECT User,Host FROM mysql.user; # 秀出系統現在有哪些 user
SHOW GRANTS FOR username@localhost; # 會秀出開此 username 時下的 Grant 語法, 也可用此來做帳號備份.
結果: GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'username'@'localhost' IDENTIFIED BY PASSWORD
結果: GRANT USAGE ON *.* TO '帳號'@'192.168.88.%' IDENTIFIED BY PASSWORD
'             GRANT SELECT, EXECUTE ON '資料庫'.* TO '帳號'@'192.168.88.%'

下述這些結果都一樣, 都是列出 目前此User 的權限.

SHOW GRANTS;
SHOW GRANTS FOR CURRENT_USER;
SHOW GRANTS FOR CURRENT_USER();
```

## 修改
```
mysql> update db set Host='202.54.10.20' where Db='webdb';
mysql> update user set Host='202.54.10.20' where user='webadmin';
```

## 刪除
```
mysql> DELETE FROM mysql.user WHERE User = 'root' AND Host = '%';
mysql> FLUSH PRIVILEGES;
```

## 刪除空帳號
```
mysql> DELETE FROM user WHERE User = '';
mysql> FLUSH PRIVILEGES;
```

## 建立新帳號
```
GRANT SELECT,INSERT,UPDATE ON datab_name.* TO user@host IDENTIFIED BY 'passwd';
GRANT ALL ON *.* TO root@'10.99.1.%' IDENTIFIED BY '密碼';

mysql> GRANT 權限 ON 資料庫或資料表 TO 使用者 IDENTIFIED BY '密碼';
資料庫或資料表
*.*所有資料庫裡的所有資料表
*預設資料庫裡的所有資料表
資料庫.*某一資料庫裡的所有資料表
資料庫.資料表某一資料庫裡的特定資料表
資料表預設資料庫裡的某一資料表
```

## 範例 把 db35 這個資料庫(含其下的所有資料表)，授權給 s35，從 localhost 上來
```
mysql> GRANT all ON bugdb.* TO bug@'localhost' IDENTIFIED BY '密碼';
mysql -h host -u user -p
```

## 安全性設定(*.*為資料庫.資料表, @前面的*表示帳號, %可改成IP比如140.92.25.1)
```
GRANT ALL PRIVILEGES ON *.* TO '*'@'%' IDENTIFIED BY '密碼' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;   （最後一定要強迫更新權限）

Permissible Privileges for GRANT and REVOKE
Privilege    Meaning
ALL [PRIVILEGES]    Grant all privileges at specified access level except GRANT OPTION
ALTER    Enable use of ALTER TABLE
ALTER ROUTINE    Enable stored routines to be altered or dropped
CREATE    Enable database and table creation
CREATE ROUTINE    Enable stored routine creation
CREATE TEMPORARY TABLES    Enable use of CREATE TEMPORARY TABLE
CREATE USER    Enable use of CREATE USER, DROP USER, RENAME USER, and REVOKE ALL PRIVILEGES
CREATE VIEW    Enable views to be created or altered
DELETE    Enable use of DELETE
DROP    Enable databases, tables, and views to be dropped
EVENT    Enable use of events for the Event Scheduler
EXECUTE    Enable the user to execute stored routines
FILE    Enable the user to cause the server to read or write files
GRANT OPTION    Enable privileges to be granted to or removed from other accounts
INDEX    Enable indexes to be created or dropped
INSERT    Enable use of INSERT
LOCK TABLES    Enable use of LOCK TABLES on tables for which you have the SELECT privilege
PROCESS    Enable the user to see all processes with SHOW PROCESSLIST
REFERENCES    Not implemented
RELOAD    Enable use of FLUSH operations
REPLICATION CLIENT    Enable the user to ask where master or slave servers are
REPLICATION SLAVE    Enable replication slaves to read binary log events from the master
SELECT    Enable use of SELECT
SHOW DATABASES    Enable SHOW DATABASES to show all databases
SHOW VIEW    Enable use of SHOW CREATE VIEW
SHUTDOWN    Enable use of mysqladmin shutdown
SUPER    Enable use of other administrative operations such as CHANGE MASTER TO, KILL, PURGE BINARY LOGS, SET GLOBAL, and mysqladmin debug command
TRIGGER    Enable trigger operations
UPDATE    Enable use of UPDATE
USAGE    Synonym for “no privileges”
```

## 顯示目前有幾個資料庫
```
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bugdb              |
| mysql              |
| test               |
+--------------------+
3 rows in set (0.00 sec)
```

## 列出該資料庫所有資料表名稱
```
mysql> SHOW TABLES FROM 資料庫名 [LIKE ...];
```

## 列出該資料表所有欄位名稱
```
mysql> SHOW COLUMNS FROM table_name [LIKE ...];
mysql> SHOW COLUMNS FROM table_name FROM db_name  [LIKE ...];
mysql> SHOW FIELDS FROM table_name [LIKE ...];
mysql> DESCRIBE table_name ;
mysql> EXPLAIN table_name ;
```

## 查詢資料庫大小
```
SELECT table_schema "DB Name", Round(Sum(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" FROM information_schema.tables GROUP BY table_schema;
+--------------------+---------------+
| DB Name            | DB Size in MB |
+--------------------+---------------+
| bugdb              |           2.5 |
| information_schema |           0.0 |
| mysql              |           0.6 |
+--------------------+---------------+
```

## 查詢MySQL VARIABLES
```
mysql> SHOW VARIABLES LIKE '%log_bin%';
+---------------------------------+-------------------------------------------------+
| Variable_name                   | Value                                           |
+---------------------------------+-------------------------------------------------+
| log_bin                         | ON                                              |
| log_bin_basename                | /rdsdbdata/log/binlog/mysql-bin-changelog       |
| log_bin_index                   | /rdsdbdata/log/binlog/mysql-bin-changelog.index |
| log_bin_trust_function_creators | ON                                              |
| log_bin_use_v1_row_events       | OFF                                             |
| sql_log_bin                     | ON                                              |
+---------------------------------+-------------------------------------------------+
```

## 建立資料庫;
```
CREATE DATABASE 資料庫名;
```

## 使用資料庫
```
USE 資料庫名;
```

## 刪除資料庫 DROP DATABASE 資料庫名;
```
DROP DATABASE [IF EXISTS] 資料庫名;
```

## 建立資料表 CREATE TABLE 資料表名 (欄位1 資料型態, 欄位2 資料型態, ......);
```
CREATE TABLE 資料表名 (autono INT NOT NULL AUTO_INCREMENT PRIMARY KEY, RACKID varchar(10), RACKLEVEL varchar(10), KVMID varchar(10), CUSERY varchar(20), SERVERENAME varchar(50), SERVERCNAME varchar(50), SERVERTYPE varchar(50), OSTYPE varchar(50), IPADDRESS varchar(20), SERVICEINFO varchar(50), CPUTYPE varchar(50), RAM varchar(20), STORAGE varchar(20), CRID varchar(50), FNTYPE varchar(20));

資料結構(type):
資料型態     說明
TINYINT     有符號的範圍是-128到127， 無符號的範圍是0到255。
SMALLINT     有符號的範圍是-32768到32767， 無符號的範圍是0到65535。
MEDIUMINT     有符號的範圍是-8388608到8388607， 無符號的範圍是0到16777215。
INT     有符號的範圍是-2147483648到2147483647， 無符號的範圍是0到4294967295。
INTEGER     INT的同義詞。
BIGINT     有符號的範圍是-9223372036854775808到 9223372036854775807，無符號的範圍是0到18446744073709551615。
FLOAT     單精密浮點數字。不能無符號。允許的值是-3.402823466E+38到- 1.175494351E-38，0 和1.175494351E-38到3.402823466E+38。
DOUBLE     雙精密)浮點數字。不能無符號。允許的值是- 1.7976931348623157E+308到-2.2250738585072014E-308、 0和2.2250738585072014E-308到1.7976931348623157E+308。
DOUBLE PRECISION     DOUBLE的同義詞。
REAL     DOUBLE的同義詞。
DECIMAL     DECIMAL值的最大範圍與DOUBLE相 同。
NUMERIC     DECIMAL的同義詞。
DATE     日期。支援的範圍是'1000-01-01'到'9999-12-31'。
DATETIME     日期和時間組合。支援的範圍是'1000-01-01 00:00:00'到'9999-12-31 23:59:59'
TIMESTAMP     時間戳記。範圍是'1970-01-01 00:00:00'到2037年的某時。
TIME     一個時間。範圍是'-838:59:59'到'838:59:59'。
YEAR     2或4位數字格式的年(內定是4位)。允許的值是1901到2155。
CHAR     固定長度，1 ～ 255個字元。
VARCHAR     可變長度，1 ～ 255個字元。

TINYBLOB

TINYTEXT     最大長度為255(2^8-1)個字符。

MEDIUMBLOB

MEDIUMTEXT     最大長度為16777215(2^24-1)個字符。

LONGBLOB

LONGTEXT     最大長度為4294967295(2^32-1)個字符。
ENUM     一個ENUM最多能有65535不同的值。
SET     一個SET最多能有64個成員。
```

## 顯示表格
```
SHOW TABLES;
```

## 刪除資料表 DROP TABLE 資料表名;
```
DROP TABLE [IF EXISTS] tbl_name [, tbl_name,...]
```

## 顯示表格結構
```
DESCRIBE infolist;
```

## 新增資料
```
INSERT INTO infolist (RACKID,RACKLEVEL,KVMID,CUSERY,SERVERENAME,SERVERCNAME,SERVERTYPE,OSTYPE,IPADDRESS,SERVICEINFO,CPUTYPE,RAM,STORAGE,CRID,FNTYPE) VALUES ('1','1','1','test','demo center','DynaManager-90','ASUS RS500-E6','CAKE v3.0.16 Alpha Final','140.92.25.6','Virtualization(DAS)','Intel(R) Xeon(R) CPU E5620  @ 2.40GH *2','24G','DAS 1TB','S/N:134IH11','DeSSerT');
```

## Using System Variables
```
SHOW VARIABLES;
SHOW VARIABLES LIKE 'wait_timeout';
SHOW VARIABLES LIKE 'interactive_timeout';
SHOW VARIABLES LIKE 'connect_timeout';
```

## 備份某個資料庫
```
mysqldump -u root -p -h 主機 資料庫名 > 資料庫備份檔名
```

## 備份all資料庫
```
mysqldump -u root -p -h 主機 --all-databases
```

## 同時備份多個MySQL資料庫
```
mysqldump -u root -p -h 主機 –databases 資料庫名1 資料庫名2 資料庫名3 > 資料庫備份檔名
```

## 備份MySQL資料庫為帶刪除表的格式,能夠讓該備份覆蓋已有資料庫而不需要手動刪除原有資料庫.
```
mysqldump -h 主機 -u root -p -–add-drop-table 資料庫名 > 資料庫備份檔名
```

## 僅備份資料庫結構
```
mysqldump -h 主機 -u root -p --no-data -–databases databasename1 databasename2 databasename3 > structurebackupfile.sql
```

## 備份MySQL資料庫某個(些)表
```
mysqldump -h 主機 -u root -p 資料庫名 specific_table1 specific_table2 > backupfile.sql
```

## 刪除資料庫的所有TABLES(DROP remove tables)
```
mysql -h 主機 -u root -p -Nse 'show tables' 資料庫名 | while read table; do mysql -u root -p -e "drop table $table" 資料庫名; done
```

## 清空資料庫的所有TABLES(Truncate empty tables)
```
mysql -h 主機 -u root -p -Nse 'SHOW TABLES' 資料庫名 | while read table; do mysql -u root -p -e "truncate table $table" 資料庫名; done
```

## 復原一個資料庫 (需先建好資料庫)
```
mysql -u root -p -h 主機 資料庫名 < 資料庫備份檔
```

## 還原壓縮的MySQL資料庫
```
gunzip < 資料庫備份檔名.sql.gz | mysql -h 主機 -u root -p 資料庫名
```

## 將資料庫轉移到新伺服器
```
mysqldump -u -p databasename | mysql –host=*.*.*.* -C databasename
```

## If you want to see only a specific variable, you can use this command. Obviously you’d want to replace the max_connect_errors in that command with the variable that you’re looking for.
```
SHOW VARIABLES LIKE '%max_connect_errors%';
```

## If you want to change the current state of a variable, you can do so easily with a command similar to this one:
```
SET GLOBAL max_connect_errors=10000;
Mysql> FLUSH HOSTS;

mysqlbinlog –start-datetime="2016-03-01 00:00:00" –stop-datetime="2016-03-16 00:00:00" -d bid mysql-bin.0001* > /root/replay.sql
```

## tips
```
You need to use the -p flag to send a password. And it's tricky because you must have no space between -p and the password.

$ mysql -h "server-name" -u "root" "-pXXXXXXXX" "database-name" < "filename.sql"

If you use a space after -p it makes the mysql client prompt you interactively for the password, and then it interprets the next command argument as a database-name:

$ mysql -h "server-name" -u "root" -p "XXXXXXXX" "database-name" < "filename.sql"
Enter password:
ERROR 1049 (42000): Unknown database 'XXXXXXXX'

To avoid password prompt just create ~/.my.cnf file as follows:

[client]
#for local server use localhost
#host=localhost
host=10.0.1.100
user=vivek
password=myPassword

[mysql]
pager=/usr/bin/less

Then:

$ mysql -h "server-name" "database-name" < "filename.sql"
```

## slow query
```
查看Server設定 ：show variables ;

其中兩個參數，一個是slow_launch_time，一個是long_query_time。
slow_launch_time跟slow query log沒有任何關係, 它代表的是thread create的一個門檻值，long_query_time才是正確的。

查看Server運作的各種設定 ： show global status;

可以用 show variables like '%slow%';過濾要找的值。

測試slow query，可以在用select搭sleep指令：
select sleep(2);

然後再去看slow query log
```