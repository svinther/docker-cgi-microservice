#!/bin/bash

if [[ "$1" != runservice ]]; then
 exec $@
fi

exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf

