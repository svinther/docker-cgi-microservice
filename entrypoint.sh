#!/bin/bash

set -m

if [[ "$1" != runservice ]]; then
 exec $@
fi

for f in /poorman-init.d/* ; do
 if [[ -x "$f" ]]; then
  eval "$f &"
  echo file $f was started with pid $!
 else
  echo Skipping non-executable file $f 
 fi
done

#Store all pids for bookkeeping
pids=$(jobs -p)

kill_pids() {
 for pid in $pids; do
  if kill -0 $pid 2>/dev/null; then
   echo Killing pid $pid
   kill $pid 2>/dev/null && wait $pid
  fi
 done
}

#on SIGINT kill jobs
int_h() {
 trap "" CHLD
 kill_pids
}
trap int_h INT TERM

#On job exit, kill all jobs and return exit code of job that exited
wait -n
exitcode=$?

echo "Something died, cleaning up"
kill_pids
#wait for graceful shutdowns
wait

exit $exitcode
