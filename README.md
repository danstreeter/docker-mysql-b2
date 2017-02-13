# MySQL Dump to Backblaze b2

### Overview
MySQL dump to Backblaze's b2 storage.

### Environment Variables

* `DB_USER`: username for the database
* `DB_PASSWORD`: password for the database
* `DB_HOST`: hostname/ip of the database server
* `DB_DUMP_FREQ`: How often to do a dump, in minutes. Defaults to 1440 minutes, or once per day.
* `B2_TARGET_DIR`: b2 target prefix e.g. backups
* `B2_ACCOUNT_ID`: b2 account id
* `B2_APPLICATION_KEY`: b2 application key

### Usage
````
docker run -d \
-e DB_HOST='mysql01.domain.tld' \
-e DB_USER='mydbuser' \
-e DB_PASSWORD='mysecretpassword' \
-e DB_DUMP_FREQ=1440 \
-e B2_TARGET_DIR='mysql01-backup' \
-e B2_ACCOUNT_ID='myb2accountid' \
-e B2_APPLICATION_KEY='myb2applicationkey' \
mitcdh/mysqldump-b2
````

### Credits
* [deitch/mysql-backup](https://hub.docker.com/r/deitch/mysql-backup/)
