#!/bin/bash

DB_DUMP_FREQ=${DB_DUMP_FREQ:-1440}
B2_TARGET_DIR=${B2_TARGET_DIR:-backup}
DB_USER=${DB_USER:-cattle}
DB_PASS=${DB_PASS:-cattle}

DB_SERVER=${DB_SERVER:-db}

TMPDIR=/tmp/backups

if [ -z "${B2_ACCOUNT_ID}" ]; then
    echo "no B2_ACCOUNT_ID found -> EXIT"
    exit 1
fi

if [ -z "${B2_APPLICATION_KEY}" ]; then
    echo "no B2_APPLICATION_KEY found -> EXIT"
    exit 1
fi

b2 authorize-account ${B2_ACCOUNT_ID} ${B2_APPLICATION_KEY} || echo "b2 account authorization failure" && exit 1

while true; do
  TIMESTAMP=$(date -u +"%Y%m%d%H%M%S")
  TARGET=db_backup_${TIMESTAMP}.gz
  
  echo -n "Backup '${B2_TARGET_DIR}/${TARGET}' of database(s) from ${DB_SERVER}: ["

  mysqldump -A -h $DB_SERVER -u$DB_USER -p$DB_PASS | gzip > "${TMPDIR}/${TARGET}"
  if [ $? -eq 0 ]
  then
    echo -n "DUMP_SUCCESS"
    b2 upload-file --noProgress "${B2_BUCKET}" "${TMPDIR}/${TARGET}" "${B2_TARGET_DIR}/${TARGET}" >/dev/null
    if [ $? -eq 0 ]
    then
      echo " | UPLOAD_SUCCESS]"
    else
      echo " | UPLOAD_FAILURE]"
    fi
  else
    echo "DUMP_FAILURE]"
  fi
  /bin/rm "${TMPDIR}/${TARGET}" >/dev/null 2>&1
  sleep $(($DB_DUMP_FREQ*60))
done