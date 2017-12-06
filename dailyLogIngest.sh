#!/bin/bash
VOL_LOGS="${VOL_LOGS:-/var/log}"
VOL_ACCT_DATA="${VOL_ACCT_DATA:-/var/cisl_acct_log}"
BASEDIR="${BASEDIR:-$VOL_ACCT_DATA/acctlogs}"
RSRCLOGS_DIR="$BASEDIR/resources-xdmod.d"
INGEST_FLAG="$BASEDIR/ingest-pending"
SHREDDER=/home/xdmod/run-shredder.sh
INGESTOR=/home/xdmod/run-ingestor.sh
OUTLOG="$VOL_LOGS/dailylogIngest.log"
ERRLOG="$VOL_LOGS/dailylogIngest.err"

SLEEP_SECS=300
RETRY_DELAY_MINUTES=60

tstamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "$tstamp Starting logingest loop in $RSRCLOGS_DIR..."
while [[ ! -d $RSRCLOGS_DIR ]] ; do
    echo "$RSRCLOGS_DIR: no such directory" >&2
    sleep $SLEEP_SECS
done
cd $RSRCLOGS_DIR || exit 1
while true ; do
    tstamp=$(date '+%Y-%m-%d %H:%M:%S')
    find . -type f -amin +$RETRY_DELAY_MINUTES \
           -name [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].rejected -print |
    while read rejpath ; do
        path="${rejpath%.rejected}"
	echo "$tstamp Retrying previously rejected file: $path"
	mv "$rejpath" "$path"
    done

    find . -type f -name [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] -print |
    while read path ; do
        $SHREDDER $path >>$OUTLOG 2>>$ERRLOG
        rc=$?
        tstamp=$(date '+%Y-%m-%d %H:%M:%S')
        if [[ $rc == 0 ]] ; then
            echo "$tstamp Unlinking $path"
            rm -f "$path"
            if [[ -f "$path" ]] ; then
                tstamp=$(date '+%Y-%m-%d %H:%M:%S')
                echo "$tstamp Error (rc=$rc) from: rm -f $path" >&2
            fi
	    touch $INGEST_FLAG
        else
            echo "$tstamp Renaming $path for later retry"
            mv "$path" "$path.rejected"
            if [[ -f $path ]] ; then
                tstamp=$(date '+%Y-%m-%d %H:%M:%S')
                echo "$tstamp Error (rc=$rc) from: mv $path $path.rejected" >&2
            fi
        fi
    done
    if [[ -f $INGEST_FLAG ]] ; then
        $INGESTOR >>$OUTLOG 2>>$ERRLOG
        rc=$?
        tstamp=$(date '+%Y-%m-%d %H:%M:%S')
        if [[ $rc == 0 ]] ; then
            echo "$tstamp Unlinking $INGEST_FLAG"
            rm -f "$INGEST_FLAG"
        fi
    fi
    sleep $SLEEP_SECS
done
