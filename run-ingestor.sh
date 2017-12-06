#!/bin/bash
#
# run-ingestor.sh
#
PROG="run-ingestor.sh"

INGESTOR="$HOME/bin/xdmod-ingestor"

prog=`basename "$INGESTOR"`
tstamp=$(date '+%Y-%m-%d %H:%M:%S')
command="$INGESTOR -v"
echo "$tstamp Running \"$command\"..."
$command
rc=$?
tstamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "$tstamp $prog exited, rc=$rc"
exit $rc



