#!/bin/bash
#
# run-shredder.sh <resource-day-file>
#
PROG="run-shredder.sh"

SHREDDER="$HOME/bin/xdmod-shredder"

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

p="$resourceLog"
date="${p##*/}"
p="${p%/*}"
type="${p##*/}"
p="${p%/*}"
resource="${p##*/}"
prog=`basename "$SHREDDER"`
tstamp=$(date '+%Y-%m-%d %H:%M:%S')
command="$SHREDDER -v -r $resource -f $type -i $resourceLog"
echo "$tstamp Running \"$command\"..."
$command
rc=$?
tstamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "$tstamp $prog exited, rc=$rc"
exit $rc


