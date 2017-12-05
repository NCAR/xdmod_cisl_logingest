#!/bin/bash
VOL_ACCT_DATA="${VOL_ACCT_DATA:-/var/cisl_acct_log}"
BASEDIR="${BASEDIR:-$VOL_ACCT_DATA/acctlogs}"
RSRCLOGS_DIR="$BASEDIR/resources-xdmod.d"
LOGINGEST=/home/xdmod/logingest.sh

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
    find . -type f +amin +$RETRY_DELAY_MINUTES \
           -name [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].rejected -print |
    while read rejpath ; do
        path="${rejpath%.rejected}"
	echo "$tstamp Retrying previously rejected file: $path"
	mv "$rejpath" "$path"
    done

    find . -type f -name [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] -print |
    while read path ; do
        $LOGINGEST $path
        rc=$?
        tstamp=$(date '+%Y-%m-%d %H:%M:%S')
        if [[ $rc == 0 ]] ; then
            echo "$tstamp Unlinking $path"
            rm -f "$path"
            if [[ -f "$path" ]] ; then
                tstamp=$(date '+%Y-%m-%d %H:%M:%S')
                echo "$tstamp Error (rc=$rc) from: rm -f $path" >&2
            fi
        else
            echo "$tstamp Renaming $path for later retry"
            mv "$path" "$path.rejected"
            if [[ -f $path ]] ; then
                tstamp=$(date '+%Y-%m-%d %H:%M:%S')
                echo "$tstamp Error (rc=$rc) from: mv $path $path.rejected" >&2
            fi
        fi
    done
    sleep $SLEEP_SECS
done
