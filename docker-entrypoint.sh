#!/bin/sh

BACKUP_DB_HOST=${BACKUP_DB_HOST:-db}
BACKUP_DB_USER=${BACKUP_DB_USER:-cattle}
BACKUP_DB_PASSWORD=${BACKUP_DB_PASSWORD:-cattle}
BACKUP_DB_NAME=${BACKUP_DB_NAME:-dbname}

B2_ACCOUNT_ID=${B2_ACCOUNT_ID}
B2_APPLICATION_KEY=${B2_APPLICATION_KEY}
BACKUP_FREQ=${BACKUP_FREQ:-1440}
B2_BUCKET=${B2_BUCKET:-bucket}
B2_TARGET_DIR=${B2_TARGET_DIR:-backup}

TMPDIR=/tmp/backups
DATE=`date +%Y-%m-%d-%H%M`
TARGET=${DATE}_${TARGET_FILENAME:-$BACKUP_DB_NAME}.sql

mkdir -p ${TMPDIR}

if [ -z "${B2_ACCOUNT_ID}" ]; then
    echo "no B2_ACCOUNT_ID found -> EXIT"
    exit 1
fi

if [ -z "${B2_APPLICATION_KEY}" ]; then
    echo "no B2_APPLICATION_KEY found -> EXIT"
    exit 1
fi

b2 authorize-account ${B2_ACCOUNT_ID} ${B2_APPLICATION_KEY}
if [ $? -eq 0 ]; then
	while true; do
	# Additional authentication call here to prevent timeout
	b2 authorize-account ${B2_ACCOUNT_ID} ${B2_APPLICATION_KEY}

	  echo -n "${DATE} - Backup 'b2://${B2_BUCKET}/${B2_TARGET_DIR}/${TARGET}' of database(s) from ${BACKUP_DB_HOST}: ["

	  mysqldump --opt --skip-lock-tables --skip-add-locks --single-transaction --routines -h ${BACKUP_DB_HOST} -u${BACKUP_DB_USER} -p${BACKUP_DB_PASSWORD} ${BACKUP_DB_NAME} > "${TMPDIR}/${TARGET}"
	  if [ $? -eq 0 ]; then
	    echo -n "DUMP_SUCCESS"
		gzip ${TMPDIR}/${TARGET}
	    b2 upload-file --noProgress "${B2_BUCKET}" "${TMPDIR}/${TARGET}.gz" "${B2_TARGET_DIR}/${TARGET}.gz" >/dev/null
	    if [ $? -eq 0 ]; then
	      echo " | UPLOAD_SUCCESS]"
	    else
	      echo " | UPLOAD_FAILURE]"
	    fi
	  else
	    echo "DUMP_FAILURE]"
	  fi
	  /bin/rm "${TMPDIR}/${TARGET}.gz" >/dev/null 2>&1
	  sleep $((${BACKUP_FREQ}*60))
	done
else
	echo "b2 account authorization failure"
	exit 1
fi
