# MySQL Dump to Backblaze b2

### Overview
MySQL dump to Backblaze's b2 storage.

### Environment Variables

* `BACKUP_DB_HOST`: hostname/ip of the database server
* `BACKUP_DB_USER`: username for the database 
* `BACKUP_DB_PASSWORD`: password for the database
* `BACKUP_DB_NAME`: name of the database to backup
* `BACKUP_FREQ`: How often to do a dump, in minutes. Defaults to 1440 minutes, or once per day.
* `TARGET_FILENAME`: Name of the file (is automatically prefixed with YYYY-MM-DD-HHMM, and suffixed with .sql.gz)
* `B2_TARGET_DIR`: b2 target prefix e.g. backups
* `B2_ACCOUNT_ID`: b2 account id
* `B2_APPLICATION_KEY`: b2 application key
* `B2_BUCKET`: b2 bucket to use

### Usage
````
docker run -d \
-e BACKUP_DB_HOST='mysql01.domain.tld' \
-e BACKUP_DB_USER='mydbuser' \
-e BACKUP_DB_PASSWORD='mysecretpassword' \
-e BACKUP_DB_NAME='mydatabase' \
-e BACKUP_FREQ=1440 \
-e TARGET_FILENAME=dbbackup \
-e B2_TARGET_DIR='mysql01-backup' \
-e B2_ACCOUNT_ID='myb2accountid' \
-e B2_APPLICATION_KEY='myb2applicationkey' \
mitcdh/mysqldump-b2
````

### Credits
* [deitch/mysql-backup](https://hub.docker.com/r/deitch/mysql-backup/)
