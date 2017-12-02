#!/bin/bash
#
# logingest.sh <resource-day-file>
#
PROG="logingest.sh"

SHREDDER="$HOME/bin/xdmod-shredder"
INGESTOR="$HOME/bin/xdmod-ingestor"

tstamp=$(date '+%Y-%m-%d %H:%M:%S')

resourceLog="$1"
if [[ -z "$resourceLog" ]] ; then
    echo "$tstamp $PROG: no argument given" >&2
    exit 1
fi
if [[ ! -f "$resourceLog" ]] ; then
    echo "$tstamp $PROG: no such file: $resourceLog" >&2
    exit 1
fi

function main() {
    p="$1"
    date="${p##*/}"
    p="${p%/*}"
    type="${p##*/}"
    p="${p%/*}"
    resource="${p##*/}"

    runCommand "$SHREDDER" -v -r "$resource" -f "$type" -i "$1"
    rc=$?
    if [[ $rc == 0 ]] ; then
        runCommand "$INGESTOR" -v
	rc=$?
    fi
    return $rc
}

function runCommand() {
    prog=`basename "$1"`
    tstamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$tstamp Running \"$@\"..."
    $@
    rc=$?
    tstamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$tstamp $prog exited, rc=$rc"
    if [[ $rc != 0 ]] ; then
        echo "$tstamp $prog error" >&2
    fi
    return $rc
}

main $resourceLog
exit $?


