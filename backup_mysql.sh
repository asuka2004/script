#!/bin/bash
PATH=/usr/local/mysql/bin/mysql
DBPATH=/root/test
MYUSER=root
MYPASS=
SOCKET=/usr/local/mysql/mysql.sock
MYCMD="mysql -u$MYUSER -p$MYPASS -S $SOCKET"
MYDUMP="mysqldump -u$MYUSER -p$MYPASS -S $SOCKET"

[ ! -d "$DBPATH" ] && mkdir $DBPATH

for dbname in `$MYCMD -e "show databases;"|sed '1,2d'`

do
 $MYDUMP $dbname| gzip >$DBPATH/${dbname}_$(date +%F).sql.gz
done

