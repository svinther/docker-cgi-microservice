#!/bin/bash

#lighttpd is logging to this
mkfifo -m 600 /tmp/logpipe
chmod a+w /tmp/logpipe
exec cat < /tmp/logpipe

