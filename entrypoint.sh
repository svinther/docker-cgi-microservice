#!/bin/bash

if [[ "$1" != runservice ]]; then
 exec $@
fi

#lighttpd is logging to this
chmod a+w /dev/pts/0

exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf

