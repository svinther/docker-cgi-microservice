#!/bin/bash

#lighttpd is logging to this
chmod a+w /dev/pts/0
exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf

