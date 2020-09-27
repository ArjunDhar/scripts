#!/bin/bash
# shrinkMysql.sh

/etc/init.d/mycampus stop

mysql -u root -padmin2008 -e "delete from portletaudit_property where event_id in ( select event_id from portletaudit_event where date < DATE_SUB(NOW(), INTERVAL 3 MONTH));" campuseai
mysql -u root -padmin2008 -e "delete from portletaudit_event where date < DATE_SUB(NOW(), INTERVAL 3 MONTH);" campuseai

mysqldump -u root -padmin2008 --all-databases > /apps/mysql/backup.sql

/etc/init.d/mysql.server stop

mkdir /apps/mysql/data.bak/
mv /apps/mysql/data/* /apps/mysql/data.bak/

rm -fr /apps/mysql/logs/*


cd /apps/mysql/current
scripts/mysql_install_db

/etc/init.d/mysql.server start

mysql -u root < /apps/mysql/backup.sql

mysql -u root -e "flush privileges;"

/etc/init.d/mycampus/start